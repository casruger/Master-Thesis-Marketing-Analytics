#tutorial link : https://www.youtube.com/watch?v=DIT8rwyPEns&ab_channel=JohnWatsonRooney
#tutorial github link: https://github.com/jhnwr/scrape-amazon-reviews
# url we want the reviews from  'https://www.amazon.nl/That-Will-Never-Work-Netflix/product-reviews/0316530204/ref=cm_cr_arp_d_paging_btm_next_2?ie=UTF8&reviewerType=all_reviews&pageNumber=1'

#first start splash from docker, than change the url at the bottom and change the attribtues in get_reviews. 



import requests
import pandas as pd
from unidecode import unidecode
import json
from bs4 import BeautifulSoup

# Program extracting first column

df = pd.read_excel('Bundesliga_get_captains.xlsx') # can also index sheet by name or fetch all sheets
list_=df.values.tolist()
captains=[]

for matches in list_:
	match=str(matches)
	match_nr=(match.find('team_id')+10)
	match_nr2=match[match_nr:match_nr+6]
	match_nr2=str(match_nr2.replace(" ", ""))
	print(match_nr2)
	start_looking1=match.find("'captain': True")
	if start_looking1<10:
		start_looking1=(match.find("True")+1)
	start1=(match.find('player_id',start_looking1)+12)
	eind1=match.find(",", start1+2)
	home_captain=match[start1:eind1]
	home_captain=str(home_captain.replace(" ", ""))
	print(home_captain)
	start_looking2=match.find("'captain': True",eind1)
	if start_looking2<10:
		start_looking2=(match.find("True",eind1)+1)
	start2=(match.find('player_id',start_looking2)+12)
	eind2=match.find(",", start2+2)
	away_captain=match[start2:eind2]
	away_captain=str(away_captain.replace(" ", ""))
	print(away_captain)
	captains.append(str(match_nr2)+":"+str(home_captain)+":"+str(away_captain))

df = pd.DataFrame(captains)
writer = pd.ExcelWriter('Bundesliga_captains.xlsx', engine='xlsxwriter')
df.to_excel(writer, index=False)
writer.save()
