#tutorial link : https://www.youtube.com/watch?v=DIT8rwyPEns&ab_channel=JohnWatsonRooney
#tutorial github link: https://github.com/jhnwr/scrape-amazon-reviews
# url we want the reviews from  'https://www.amazon.nl/That-Will-Never-Work-Netflix/product-reviews/0316530204/ref=cm_cr_arp_d_paging_btm_next_2?ie=UTF8&reviewerType=all_reviews&pageNumber=1'

#first start splash from docker, than change the url at the bottom and change the attribtues in get_reviews. 



import requests
from bs4 import BeautifulSoup
import pandas as pd

reviewlist = []

Players_value={}

def get_soup(url): 
	print(url)
	r=requests.get('http://localhost:8050/render.html', params={'url': url, 'wait': 2})
	soup= BeautifulSoup(r.text, 'html.parser')
	players_odd= soup.find_all(class_='odd')
	for player in players_odd:
		player_name=player.find('div', class_='di nowrap')
		waarde=player.find('td', class_="rechts hauptlink")
		Players_value[str(player_name.text)]=str(waarde.text)
	players_even=soup.find_all(class_='even')
	for player in players_even:
		player_name=player.find('div', class_='di nowrap')
		waarde=player.find('td', class_="rechts hauptlink")
		Players_value[str(player_name.text)]=str(waarde.text)
		


get_soup("https://www.transfermarkt.com/celtic-glasgow/startseite/verein/371/saison_id/2020")
get_soup("https://www.transfermarkt.com/glasgow-rangers/startseite/verein/124/saison_id/2020")
get_soup("https://www.transfermarkt.com/hibernian-fc/startseite/verein/903/saison_id/2020")
get_soup("https://www.transfermarkt.com/aberdeen-fc/startseite/verein/370/saison_id/2020")
get_soup("https://www.transfermarkt.com/motherwell-fc/startseite/verein/987/saison_id/2020")
get_soup("https://www.transfermarkt.com/dundee-united-fc/startseite/verein/1519/saison_id/2020")
get_soup("https://www.transfermarkt.com/livingston-fc/startseite/verein/1241/saison_id/2020")
get_soup("https://www.transfermarkt.com/st-johnstone-fc/startseite/verein/2578/saison_id/2020")
get_soup("https://www.transfermarkt.com/ross-county-fc/startseite/verein/2759/saison_id/2020")
get_soup("https://www.transfermarkt.com/kilmarnock-fc/startseite/verein/2553/saison_id/2020")
get_soup("https://www.transfermarkt.com/hamilton-academical-fc/startseite/verein/2999/saison_id/2020")
get_soup("https://www.transfermarkt.com/st-mirren-fc/startseite/verein/465/saison_id/2020")




string=[]
for item in Players_value:
	waardengoed=str(Players_value[item])
	waardengoed=waardengoed.replace('\xa0\xa0', '')
	if "m" in waardengoed: #site shows m instead of million 
		waardengoed=waardengoed.replace('.', "")
		waardengoed=waardengoed.replace('m', "0")
	elif "Th" in waardengoed: #site shows th instead of thousands
		waardengoed=waardengoed.replace("Th.","")
	else: 
		waardengoed="Fout, handmatig zoeken"
	string.append(item+":" +waardengoed)


df = pd.DataFrame(string)
writer = pd.ExcelWriter('Scotisch-Player_Values_2021season.xlsx', engine='xlsxwriter')
df.to_excel(writer, index=False)
df.to_excel(writer,startrow=len(df)+1, index=False, header=None)
writer.save()

#dictio met <player>,<waarde>
'''


'''