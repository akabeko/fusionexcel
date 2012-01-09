<%
Function render_links_by_category(link_type, category_id, category_title)
    Dim objXml, linkObj
    set objXml = GetIndexedLinks(link_type, category_id)
    set linkObj = objXml.selectNodes("links/link")
    
    Dim item, index, column_index
    
    Dim link_id, link_title, link_short_description, l_link_type, article_id, category_code, publish, external_url, image_url
    
    column_index = 0
    %>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#eef0fc" style="border: solid 1px #000000">
        <tbody>
            <tr>
                <td width="738" height="25" valign="top">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" background="img/buttonbg2.gif">
                        <tbody>
                            <tr>
                                <td width="738" height="25" class="header_title style1"><span style="padding-left: 10px; color: #fff"><%= category_title %></span></td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td height="222" valign="top">
                    <table width="100%" border="0" cellpadding="0" cellspacing="10">
                        <tbody>
                            <tr>
                                <td width="718" height="200" valign="top">
                                    <table width="718" border="0" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <%
                                            for each item in linkObj
                                                if column_index = 0 then
                                                    %><tr><%
                                                    column_index = column_index + 1
                                                end if
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
                                                    %>
                                                    <td width="280" valign="middle" bgcolor="#87A6E3" class="header_title"><%= link_short_description %></td>
                                                    <td width="79" align="right">
                                                        <a href="<%= external_url %>" target="_blank">
                                                            <img src="<%= image_url %>" width="72" height="65" border="0" />
                                                        </a>
                                                    </td>
                                                    <%
                                                    column_index = column_index + 1
                                                end if
                                                if column_index = 2 then
                                                    %><td width="21"></td><%
                                                elseif column_index = 3 then
                                                    %></tr><tr><td height="8" colspan="5" valign="middle" class="header_title"></td></tr><%
                                                    column_index = 0
                                                end if
                                            next
                                            %>
                                            <%
                                            if column_index = 1 then
                                                %><td height="8" colspan="5" valign="middle" class="header_title"></td></tr><%
                                            elseif column_index = 2 then
                                                %><td colspan="2"></td><%
                                            end if
                                            %>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
    <%
End Function     
%>