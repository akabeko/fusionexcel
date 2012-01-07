<%
Function render_header_image(category_code)
%>
<% if category_code = 2 then %>
<img src="img/banner_charities.jpg" width="740" height="170" />
<% elseif category_code = 4 then %>
<img src="img/banner_sponsor.jpg" width="740" height="170" />
<% elseif category_code = 8 then %>
<img src="img/banner_companyspokesmen.jpg" width="740" height="170" />
<% elseif category_code = 16 then %>
<img src="img/banner_corporate.jpg" width="740" height="170" />
<% elseif category_code = 32 then %>
<img src="img/banner_testimonial.jpg" width="740" height="170" />
<% elseif category_code = 64 then %>
<img src="img/banner_beauty.jpg" width="740" height="170" />
<% elseif category_code = 128 then %>
<img src="img/banner_qc.jpg" width="740" height="170" />
<% elseif category_code = 256 then %>
<img src="img/banner_quantumscience.jpg" width="740" height="170" />
<% elseif category_code = 512 then %>
<img src="img/banner_incomeplan.jpg" width="740" height="170" />
<% elseif category_code = 1024 then %>
<img src="img/banner_faq.jpg" width="740" height="170" />
<% elseif category_code = 2048 then %>
<img src="img/banner_testimonials_video.jpg" width="740" height="170" />
<% else %>
<img src="img/banner_news.jpg" width="740" height="170" />
<% end if %>
<%
End Function

%>