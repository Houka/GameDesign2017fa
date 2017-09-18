import os
import sys

if __name__ == "__main__":
	build_language = "html5"
	try:
		if len(sys.argv) > 1:
			build_language = sys.argv[1]

		# relocate to the directory of this file then run cmd
		abspath = os.path.abspath(__file__)
		dname = os.path.dirname(abspath)
		os.chdir(dname)
		print(os.getcwd())
		os.system("lime test "+build_language+" -debug")
	except Error:
		print("could NOT build and run with "+build_language)