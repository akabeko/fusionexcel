<%
Function render_links_by_category(link_type, category_id)
    Dim objXml, linkObj
    set objXml = GetIndexedLinks(link_type, category_id)
    set linkObj = objXml.selectNodes("links/link")
    
    Dim item, index
    
    Dim link_id, link_title, link_short_description, l_link_type, article_id, category_code, publish, external_url, image_url
    for each item in linkObj
        link_id = item.childNodes(0).text
        link_title = item.childNodes(lang_index).text
        link_short_description = item.childNodes(lang_index + 3).text
        article_id = item.childNodes(7).text
        category_code = item.childNodes(8).text
        image_url = item.childNodes(9).text
        publish  = item.childNodes(10).text
        l_link_type = item.childNodes(11).text
        external_url = item.childNodes(12).text
        
        if LCase(publish) = "true" then
            
        end if
    next
End Function     
%>