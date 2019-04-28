from bs4 import BeautifulSoup
import urllib.request
import json

page = urllib.request.urlopen('https://iatw.cnaf.infn.it/eee/monitor/')
soup = BeautifulSoup(page)

eeeactivestations = []

#giusto per vedere se tutto funziona
x = soup.find('title').get_text()
print(x)

table_row = soup.find('tr')
table_without_headers = table_row.find_next_siblings('tr')

index = 0
#c'è l'offset a zero, invece su flutter? boh
for row in table_without_headers:
    
     telescope = {"id": index}
     print("row number:", index)
     
     telescope_status = row['class']
     print(telescope_status)
     
     telescope["telescope_status"] = telescope_status
    
     
     columns = row.contents
     
     school_name = columns[0].contents[0].get_text()
     print(school_name)
     
     telescope["school_name"] = school_name
          
     files_sent = columns[4].contents[0]
     print(files_sent)
     
     telescope["files_sent"] = files_sent
     
     last_file_sent = columns[3].get_text()
     print(last_file_sent)
     
     telescope["last_file_sent"] = last_file_sent
     
     last_elog_entry = columns[5].get_text()
     print(last_elog_entry)
     
     telescope["last_elog_entry"] = last_elog_entry
     
     rate_of_triggers = columns[8].get_text()
     print(rate_of_triggers)
     
     telescope["rate_of_triggers"] = rate_of_triggers
     
     rate_of_tracks = columns[9].get_text()
     print(rate_of_tracks)
     
     telescope["rate_of_tracks"] = rate_of_tracks
     
     #per sicurezza
     dqm_link = "<a href=\"dqm2/" + school_name + "?C=M;O=D\">" + school_name + "</a>"
     print(dqm_link)
     
     telescope["dqm_link"] = dqm_link
     
#     print(row)
     print("\n\n")
     index = index + 1
     
     eeeactivestations.append(telescope)
     
     pass

json_eeeactivestations = json.dumps(eeeactivestations)
print(json_eeeactivestations)
