<!DOCTYPE html>
<html>
<head>
<title>JBossEAP6.0 JSP snoop page</title>
<%@ page import="javax.servlet.http.HttpUtils,java.util.Enumeration"%>
<%@ page import="java.lang.management.*"%>
<%@ page import="java.util.*"%>
</head>
<body>

	<h1>WebApp JSP Snoop page</h1>
	<img src="images/jbosscorp_logo.png" alt="">

	<h2>JVM Memory Monitor</h2>


	<table border="0" width="100%">

		<tbody>
			<tr>
				<td colspan="2" align="center">
					<h3>Memory MXBean</h3>
				</td>
			</tr>

			<tr>
				<td width="200">Heap Memory Usage</td>
				<td><%=ManagementFactory.getMemoryMXBean().getHeapMemoryUsage()%>
				</td>
			</tr>

			<tr>
				<td>Non-Heap Memory Usage</td>
				<td><%=ManagementFactory.getMemoryMXBean()
					.getNonHeapMemoryUsage()%></td>
			</tr>

			<tr>
				<td colspan="2"></td>
			</tr>

			<tr>
				<td colspan="2" align="center">
					<h3>Memory Pool MXBeans</h3>
				</td>
			</tr>

		</tbody>
	</table>
	<%
		Iterator iter = ManagementFactory.getMemoryPoolMXBeans().iterator();
		while (iter.hasNext()) {
			MemoryPoolMXBean item = (MemoryPoolMXBean) iter.next();
	%>

	<table style="border: 1px #98AAB1 solid;" border="0" width="100%">

		<tbody>
			<tr>
				<td colspan="2" align="center"><strong><%=item.getName()%></strong></td>
			</tr>

			<tr>
				<td width="200">Type</td>
				<td><%=item.getType()%></td>
			</tr>

			<tr>
				<td>Usage</td>
				<td><%=item.getUsage()%></td>
			</tr>

			<tr>
				<td>Peak Usage</td>
				<td><%=item.getPeakUsage()%></td>
			</tr>

			<tr>
				<td>Collection Usage</td>
				<td><%=item.getCollectionUsage()%></td>
			</tr>

		</tbody>
	</table>


	<%
		}
	%>

	<h2>Request information</h2>

	<table>
		<tr>
			<th align="right">Requested URL:</th>
			<td><%=HttpUtils.getRequestURL(request)%></td>
		</tr>
		<tr>
			<th align="right">Request method:</th>
			<td><%=request.getMethod()%></td>
		</tr>
		<tr>
			<th align="right">Request URI:</th>
			<td><%=request.getRequestURI()%></td>
		</tr>
		<tr>
			<th align="right">Request protocol:</th>
			<td><%=request.getProtocol()%></td>
		</tr>
		<tr>
			<th align="right">Servlet path:</th>
			<td><%=request.getServletPath()%></td>
		</tr>
		<tr>
			<th align="right">Path info:</th>
			<td><%=request.getPathInfo()%></td>
		</tr>
		<tr>
			<th align="right">Path translated:</th>
			<td><%=request.getPathTranslated()%></td>
		</tr>
		<tr>
			<th align="right">Query string:</th>
			<td>
				<%
					if (request.getQueryString() != null)
						out.write(request.getQueryString().replaceAll("<", "&lt;")
								.replaceAll(">", "&gt;"));
				%>
			</td>
		</tr>
		<tr>
			<th align="right">Content length:</th>
			<td><%=request.getContentLength()%></td>
		</tr>
		<tr>
			<th align="right">Content type:</th>
			<td><%=request.getContentType()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Server name:</th>
			<td><%=request.getServerName()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Server port:</th>
			<td><%=request.getServerPort()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Remote user:</th>
			<td><%=request.getRemoteUser()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Remote address:</th>
			<td><%=request.getRemoteAddr()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Remote host:</th>
			<td><%=request.getRemoteHost()%></td>
		</tr>
		<tr>
		</tr>
		<tr>
			<th align="right">Authorization scheme:</th>
			<td><%=request.getAuthType()%></td>
		</tr>
		<tr>
		</tr>
	</table>

	<%
		Enumeration e = request.getHeaderNames();
		if (e != null && e.hasMoreElements()) {
	%>
	<h2>Request headers</h2>

	<table>
		<tr>
			<th align="left">Header:</th>
			<th align="left">Value:</th>
		</tr>
		<%
			while (e.hasMoreElements()) {
					String k = (String) e.nextElement();
		%>
		<tr>
			<td><%=k%></td>
			<td><%=request.getHeader(k)%></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>


	<%
		e = request.getParameterNames();
		if (e != null && e.hasMoreElements()) {
	%>
	<h2>Request parameters</h2>
	<table>
		<tr valign="top">
			<th align="left">Parameter:</th>
			<th align="left">Value:</th>
			<th align="left">Multiple values:</th>
		</tr>
		<%
			while (e.hasMoreElements()) {
					String k = (String) e.nextElement();
					String val = request.getParameter(k);
					String vals[] = request.getParameterValues(k);
		%>
		<tr valign="top">
			<td><%=k.replaceAll("<", "&lt;").replaceAll(">", "&gt;")%></td>
			<td><%=val.replaceAll("<", "&lt;").replaceAll(">",
							"&gt;")%></td>
			<td>
				<%
					for (int i = 0; i < vals.length; i++) {
								if (i > 0)
									out.print("<BR>");
								out.print(vals[i].replaceAll("<", "&lt;").replaceAll(
										">", "&gt;"));
							}
				%>
			</td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>


	<%
		e = request.getAttributeNames();
		if (e != null && e.hasMoreElements()) {
	%>
	<h2>Request Attributes</h2>
	<table>
		<tr valign="top">
			<th align="left">Attribute:</th>
			<th align="left">Value:</th>
		</tr>
		<%
			while (e.hasMoreElements()) {
					String k = (String) e.nextElement();
					Object val = request.getAttribute(k);
		%>
		<tr valign="top">
			<td><%=k.replaceAll("<", "&lt;").replaceAll(">", "&gt;")%></td>
			<td><%=val.toString().replaceAll("<", "&lt;")
							.replaceAll(">", "&gt;")%></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>


	<%
		e = getServletConfig().getInitParameterNames();
		if (e != null && e.hasMoreElements()) {
	%>
	<h2>Init parameters</h2>
	<table>
		<tr valign="top">
			<th align="left">Parameter:</th>
			<th align="left">Value:</th>
		</tr>
		<%
			while (e.hasMoreElements()) {
					String k = (String) e.nextElement();
					String val = getServletConfig().getInitParameter(k);
		%>
		<tr valign="top">
			<td><%=k%></td>
			<td><%=val%></td>
		</tr>
		<%
			}
		%>
	</table>
	<%
		}
	%>

</body>
</html>

