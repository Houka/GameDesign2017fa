import sys
import json

def get_data(file):
	f = open(file,'r')
	j = json.loads(f.read())

	finished = {}
	unfinished = {}
	for pq in j["player_quests"]:
		quest = pq["quest_id"]
		if pq["end_timestamp"] == None:
			if quest not in unfinished:
				unfinished[quest] = 1
			else:
				unfinished[quest] += 1
		else:
			if quest not in finished:
				finished[quest] = 1
			else:
				finished[quest] += 1

	total = 0
	for v in finished.values():
		total += v
	finished["total"] = total

	total = 0
	for v in unfinished.values():
		total += v
		unfinished["total"] = total

	print "Finished Levels:"
	print json.dumps(finished, indent=2, sort_keys=True)
	print "\nUnfinished Levels:"
	print json.dumps(unfinished, indent=2, sort_keys=True)

def main():
	get_data(sys.argv[1])

if __name__ == "__main__":
	main()