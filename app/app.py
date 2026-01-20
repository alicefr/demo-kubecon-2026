from http.server import BaseHTTPRequestHandler, HTTPServer

class SimpleHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        print(f"[*] DUMPED DATA: {post_data}")
        if "secretpassword" in post_data:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Login Successful\n")
        else:
            self.send_response(403)
            self.end_headers()
            self.wfile.write(b"Access Denied\n")

httpd = HTTPServer(('0.0.0.0', 8080), SimpleHandler)
print("Demo Server Running...")
httpd.serve_forever()
