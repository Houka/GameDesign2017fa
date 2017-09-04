import os
import sys

if __name__ == "__main__":
	build_language = "html5"
	try:
		if len(sys.argv) > 1:
			build_language = sys.argv[1]
		os.system("lime test "+build_language)
	except Error:
		print("could NOT build and run with "+build_language)