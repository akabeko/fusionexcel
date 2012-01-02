<%
Dim ckfinder_folder_path, frontend_css_folder_path

Dim root_url

Dim base_lang
'Base URI'
Dim base_url
'Common Path'
Dim data_path, article_path, service_centres_path, indexed_path, links_path
'DB Path'
Dim main_db, reference_db, article_db, user_db, service_centre_db, links_db
'XML Path'
Dim category_ref_xml

'Indexed Files'
Dim article_indexed_xml
Dim service_centres_indexed_xml
Dim links_indexed_xml

base_lang = 1

root_url = "http://www.fusionexcel.com"

base_url = "/"

data_path = "data/"
article_path = "articles/"
service_centres_path = "service_centres/"
indexed_path = "indexed/"
links_path = "links/"

main_db = "main.mdb"
reference_db = "reference.mdb"
user_db = "users.mdb"
article_db = "article.mdb"
service_centre_db = "service_centres.mdb"
links_db = "links.mdb"

category_ref_xml = "references/category.xml"

article_indexed_xml = "articles_indexed.xml"
service_centres_indexed_xml = "service_centres_indexed.xml"
links_indexed_xml = "links.xml"


ckfinder_folder_path = "js/ckfinder/"
frontend_css_folder_path = "css/"
%>