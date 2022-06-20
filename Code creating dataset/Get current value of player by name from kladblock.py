#tutorial link : https://www.youtube.com/watch?v=DIT8rwyPEns&ab_channel=JohnWatsonRooney
#tutorial github link: https://github.com/jhnwr/scrape-amazon-reviews
# url we want the reviews from  'https://www.amazon.nl/That-Will-Never-Work-Netflix/product-reviews/0316530204/ref=cm_cr_arp_d_paging_btm_next_2?ie=UTF8&reviewerType=all_reviews&pageNumber=1'

#first start splash from docker, than change the url at the bottom and change the attribtues in get_reviews. 



import requests
import pandas as pd
from unidecode import unidecode
import json
from bs4 import BeautifulSoup



list_url=[]
players=[]
def file_reader(file_name):
	file=open(file_name, encoding="utf8")
	text=file.readlines()
	all_players=[]
	for line in text:
		player=str(line)
		players.append(player)
		print(player)
	for item in players:
		tijdelijk=str(item)
		tijdelijk=tijdelijk.replace('[','').replace(']','').replace("'", "")
		url='https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query='+str(tijdelijk) #use search function of website
		list_url.append(url)

file_reader('SerieA_missing_value.txt')

players_worth=[]
for item in list_url:
	print(item)
	r=requests.get('http://localhost:8050/render.html', params={'url': item, 'wait': 1})
	soup= BeautifulSoup(r.text, 'html.parser')
	players_info= soup.find('td', class_='rechts hauptlink')
	name=str(item)
	name=name.replace("https://www.transfermarkt.com/schnellsuche/ergebnis/schnellsuche?query=", "")
	name=name.replace("\n", "")
	print(name)
	if players_info is not None  :
		print(players_info.text)
		waardengoed=str(players_info.text)
		if "m" in waardengoed:
			waardengoed=waardengoed.replace('.', "")
			waardengoed=waardengoed.replace('m', "0")
		elif "Th" in waardengoed:
			waardengoed=waardengoed.replace("Th.","")
		else: 
			waardengoed="Geen waarde"
		players_worth.append(name+":"+waardengoed)
	else:
		players_worth.append(name+":"+"Fout, geen speler gevonden")
print(players_worth)



df = pd.DataFrame(players_worth)
writer = pd.ExcelWriter('SerieA_missing_value_players.xlsx', engine='xlsxwriter')
df.to_excel(writer, index=False)
df.to_excel(writer,startrow=len(df)+1, index=False, header=None)
writer.save()
	
