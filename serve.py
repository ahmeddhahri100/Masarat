import http.server
import socketserver
import os

PORT = 5000
DIRECTORY = os.path.join(os.path.dirname(__file__), "masarat", "build", "web")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def log_message(self, format, *args):
        pass

class ReuseAddrTCPServer(socketserver.TCPServer):
    allow_reuse_address = True

with ReuseAddrTCPServer(("0.0.0.0", PORT), Handler) as httpd:
    print(f"Serving Flutter web app at http://0.0.0.0:{PORT}")
    print(f"Directory: {DIRECTORY}")
    httpd.serve_forever()
