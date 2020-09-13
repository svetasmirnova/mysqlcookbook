<%-- counter.jsp: demonstrate object and class variable counters --%>

<% int counter1 = 0; %>     <%-- object variable --%>
<%! int counter2 = 0; %>    <%-- class variable --%>
<% counter1 = counter1 + 1; %>
<% counter2 = counter2 + 1; %>
<p>Counter 1 is <%= counter1 %></p>
<p>Counter 2 is <%= counter2 %></p>
