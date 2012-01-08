<!--#include file="../libraries.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ZH" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="css/style.css?1" rel="stylesheet" type="text/css" />
	<link href="css/dropdownmenu/dropdownmenu.css" rel="stylesheet" type="text/css" />
	<link href="css/smoothness/jquery-ui-1.8.16.custom.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="js/jquery-1.6.4.min.js"></script>
    <script type="text/javascript">
        var categories = new Array(
            <%
                Dim categories, index, size
                categories = getCategoriesList()
                size = UBound(categories, 2) - 1
                For index = 0 to UBound(categories, 2)
                    if categories(1, index) <> "" then
                    %>"<%= categories(1, index) %>"<%
                    if index < size then %>,<% end if
                    end if
                Next
            %>
        );
        var category_ids = new Array(
            <%
                For index = 0 to UBound(categories, 2)
                    if categories(1, index) <> "" then
                    %><%= categories(0, index) %><%
                    if index < size then %>,<% end if
                    end if
                Next
            %>
        );
        $(function() {
            $('#id_search_form').submit(function(e) {
                $('#id_search_query_error').fadeOut();
                var search_query = $(this).find('#id_search_query').val();
                
                if (search_query == "") {
                    $('#id_search_query_error').html("Search keyword cannot be empty").fadeIn();
                    return false;
                } else if (search_query.length < 4) {
                    $('#id_search_query_error').html("Search keyword is too short to be search").fadeIn();
                    return false;
                }
                return true;
            });
            $('.select_this').click(function(e) {
                var article_id = $(this).attr('data-article-id');
                var title = $('#id_article_title_' + article_id).val();
                var category_code = $('#id_article_category_code_' + article_id).val();
                
                $('#id_article_name', window.parent.document).val(title);
                $('#id_article_id', window.parent.document).val(article_id);
                $('#id_article_category_code', window.parent.document).val(category_code);
                $('#id_article_category_code_list', window.parent.document).html('');
                
                var size = categories.length;
                for (var i = 0; i < size; i ++) {
                    if (((category_code / category_ids[i]) % 2) == 1) {
                        var new_option = '<option value="' + category_ids[i] + '">' + categories[i] + '</option>';
                        $('#id_article_category_code_list', window.parent.document).append(new_option);
                    }
                }
            
                self.parent.tb_remove();
            });
            
        });
</script>
</head>
<body>


<div style="margin: 5px;">
    <form method="post" id="id_search_form">
        <p id="id_search_query_error" style="color: red; display: none;"></p>
        <label for="id_search_query">Search: </label><input type="text" name="search_query" id="id_search_query" value="<%= Request("search_query") %>" size="50" /> <input type="submit" name="search" value="Search" />
    </form>
    <br /><br />
    <table width="100%" border="1" cellpadding="2" cellspacing="2" class="article_listing listing">
        <thead>
            <tr>
                <td>Article ID</td>
                <td>Article Title</td>
                <td>Category</td>
            </tr>
        </thead>
        <tbody>
        <%
            if Request.ServerVariables("REQUEST_METHOD") = "POST" then
                Dim RecordSet, sql, search_query

                    if Request("search_query") <> "" and Len(Request("search_query")) >= 4 then
                        search_query = Request("search_query")
                    end if

                    sql = "SELECT article_id, title, category_code FROM article WHERE title LIKE '%" & Replace(search_query, " ", "%") & "%'"
                    sql = sql & " ORDER BY title"

                    call SetConnection(GetArticleDbPath())
                    call OpenDatabase()
                    call CreateRecordSet(RecordSet, sql)
                    
                Do While not RecordSet.EOF
            %>
                <tr>
                    <td>
                        <%= RecordSet("article_id") %>
                        <input type="hidden" name="article_id" id="id_article_id_<%= RecordSet("article_id") %>" value="<%= RecordSet("article_id") %>">
                        <input type="hidden" name="title" id="id_article_title_<%= RecordSet("article_id") %>" value="<%= RecordSet("title") %>">
                        <input type="hidden" name="category_code" id="id_article_category_code_<%= RecordSet("article_id") %>" value="<%= RecordSet("category_code") %>">
                    </td>
                    <td><a class="select_this" data-article-id="<%= RecordSet("article_id") %>" href="#"><%= RecordSet("title") %></a></td>
                    <td><%= getCategoriesNameById(RecordSet("category_code")) %></td>
                </tr>
                <% RecordSet.MoveNext %>
            <%
                Loop
            end if
        %>
        </tbody>
    </table>
</div>
</body>
</html>