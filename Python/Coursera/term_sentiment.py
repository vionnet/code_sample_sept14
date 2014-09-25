import json
import sys
from string import punctuation

def hw():
    print 'Hello, world!'

def lines(fp):
    #print str(len(fp.readlines()))
    scores = {}
    for line in fp:
        term, score = line.split("\t")
        scores[term] = int(score)
    print score.items()

def textScore():
    scores = dict()
    sent_file = open(sys.argv[1])
    scores = {}
    for line in sent_file:
        term, score = line.split("\t")
        scores[term] = int(score)
    return scores

#def 

def main():
    scores = textScore() 
    tweet_file = open(sys.argv[2])
    tweet_data = {}

    #list for words not in sentiment file
    nlst = []
    nscore = []
    for line in tweet_file:
        tweet_data = json.loads(line)
        if tweet_data.has_key(u'text'):
	    words = tweet_data["text"].split()
	    line_score = 0
	    #temp list for the line
            tlst = []
            for word in words:
		word2 = word.encode('utf-8')
	        for p in list(punctuation):
		    word2 = word2.replace(p,'')
                word2 = word2.lower()
                try:
	    	    line_score = line_score + scores[word2]
                except:
	    	    line_score = line_score + 0 
		    if word2 in tlst:
                       #word2.lower() already appeared in line, 
                       #updating line score
		        tlst[tlst.index(word2)+1] = line_score 
		    else:
			#set up temp list (tlst) to be in the order of 
                        #word, current line score of word.
			tlst.append(word2.lower())
			tlst.append(line_score)
             

            print(tlst)
   
if __name__ == '__main__':
    main()
