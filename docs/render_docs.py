import markdown
import os
import re
import subprocess
import shutil

# Ensure the output directory exists
output_dir = "docs/output"
os.makedirs(output_dir, exist_ok=True)

# Install mermaid.cli if not already available
try:
    # Check if mmdc is already in PATH
    subprocess.run(["which", "mmdc"], check=True, capture_output=True)
    print("mmdc (mermaid.cli) is already in PATH.")
except subprocess.CalledProcessError:
    print("mmdc not found in PATH. Attempting to install mermaid.cli globally using yarn...")
    try:
        subprocess.run(["yarn", "global", "add", "@mermaid-js/mermaid-cli"], check=True, capture_output=True)
        print("mermaid.cli installed globally.")
    except subprocess.CalledProcessError as e:
        print(f"Error installing mermaid.cli: {e.stderr.decode()}")
        print("Please ensure Node.js and Yarn are installed and accessible, or install mmdc manually.")
        exit(1)

# Function to render Mermaid to SVG
def render_mermaid_to_svg(mermaid_code, output_filepath):
    temp_mmd_file = os.path.join(output_dir, "temp_mermaid.mmd")
    with open(temp_mmd_file, "w") as f:
        f.write(mermaid_code)
    try:
        # Use mmdc to render the diagram
        subprocess.run(
            ["mmdc", "-i", temp_mmd_file, "-o", output_filepath, "-t", "neutral"],
            check=True,
            capture_output=True
        )
        print(f"Rendered Mermaid to {output_filepath}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error rendering Mermaid diagram: {e.stderr.decode()}")
        print(f"Mermaid code that caused error: \n{mermaid_code}")
        return False
    finally:
        if os.path.exists(temp_mmd_file):
            os.remove(temp_mmd_file)

# Function to process a single Markdown file
def process_markdown_file(filepath):
    print(f"Processing {filepath}...")
    with open(filepath, "r") as f:
        content = f.read()

    # Find all mermaid code blocks
    mermaid_blocks = re.findall(r"```mermaid\n(.*?)\n```", content, re.DOTALL)

    # Directory for SVGs specific to this markdown file
    base_filename = os.path.splitext(os.path.basename(filepath))[0]
    svg_output_dir = os.path.join(output_dir, base_filename + "_svgs")
    os.makedirs(svg_output_dir, exist_ok=True)

    for i, mermaid_code in enumerate(mermaid_blocks):
        svg_filename = f"{base_filename}_diagram_{i}.svg"
        svg_filepath = os.path.join(svg_output_dir, svg_filename)
        if render_mermaid_to_svg(mermaid_code, svg_filepath):
            # Replace the mermaid block with an image tag pointing to the SVG
            # Use a relative path for the HTML output
            relative_svg_path = os.path.join(base_filename + "_svgs", svg_filename)
            content = content.replace(f"```mermaid\n{mermaid_code}\n```", f'<img src="{relative_svg_path}" alt="Mermaid Diagram">', 1)
        else:
            print(f"Could not render Mermaid block in {filepath}. Keeping original block.")

    # Convert remaining Markdown to HTML
    html_content = markdown.markdown(content, extensions=['fenced_code'])

    # Write HTML to output file
    output_html_filename = base_filename + ".html"
    output_html_filepath = os.path.join(output_dir, output_html_filename)
    with open(output_html_filepath, "w") as f:
        f.write(html_content)
    print(f"Generated {output_html_filepath}")

# Iterate through all .md files in the docs directory
for root, _, files in os.walk("docs"):
    for file in files:
        if file.endswith(".md") and file != "GEMINI.md": # Exclude GEMINI.md or other non-documentation markdown
            process_markdown_file(os.path.join(root, file))

print("Documentation rendering complete.")

import http.server
import socketserver

PORT = 8000

class DocHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=output_dir, **kwargs)

def serve_docs():
    # Store the original working directory
    original_cwd = os.getcwd()
    os.chdir(output_dir) # Change to the output directory to serve files correctly
    
    with socketserver.TCPServer(("", PORT), DocHandler) as httpd:
        print(f"\nServing documentation at http://localhost:{PORT}")
        print("Press Ctrl+C to stop the server.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
        finally:
            httpd.shutdown() # Ensure server is properly shut down
            httpd.server_close() # Close the server socket
            os.chdir(original_cwd) # Change back to original directory

serve_docs() # Start serving after rendering

