import os

if __name__ == "__main__":
	try:
		os.system("cd .. & lime test neko")
	except Error:
		print("could NOT build and run with neko")