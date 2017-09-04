import os

if __name__ == "__main__":
	try:
		os.system("lime test ..\\Project.xml neko")
	except Error:
		print("could NOT build and run with neko")