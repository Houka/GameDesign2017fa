from Naked.toolshed.shell import execute_js, muterun_js
import SimpleHTTPServer
import SocketServer

PORT = 8000

version = 4
offset = 220

if __name__ == "__main__":

	json = execute_js('fetch_data.js ' + str(version) + ' ' + str(offset))
	print("JSON data updated")

	Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
	httpd = SocketServer.TCPServer(("", PORT), Handler)

	print "Server run at port", PORT
	httpd.serve_forever()