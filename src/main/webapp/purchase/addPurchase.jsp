<%@ page contentType="text/html; charset=EUC-KR" %>

<%@page import="com.model2.mvc.service.domain.Purchase"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	


<html>
<head>
<title>Insert title here</title>
<script type="text/javascript">

function fncAddPurchase(){
	$("form").attr("method" , "POST").attr("action" , "/purchase/updatePurchaseView?tranNo=${purchase.tranNo}").submit();
}

</script>
</head>

<body>

<%-- <form name="updatePurchase" action="/purchase/updatePurchaseView?tranNo=${purchase.tranNo}" method="post"> --%>
<form name="detailForm">

������ ���� ���Ű� �Ǿ����ϴ�.

<table border=1 cellspacing="5">
	<tr>
		<td width="200" height="50">��ǰ��ȣ</td>
		<td>${purchase.purchaseProd.prodNo}</td>
		<%-- <td><%=purchase.getPurchaseProd().getProdNo() %></td> --%>
		
	</tr>
	<tr>
		<td width="200" height="50">�����ھ��̵�</td>
		<td>${purchase.buyer.userId}</td>

	</tr>
	<tr>
		<td width="200" height="50">���Ź��</td>
		<td>		
		<%-- <%if(purchase.getPaymentOption().trim().equals("1")){%>
			���ݱ���
		<%}else{%>
			�ſ뱸��
		<%} %> --%>
		<c:choose>
			<c:when test="${ (fn:trim(purchase.paymentOption)) == '1'}"> 
				���ݱ���
			</c:when>
			<c:otherwise>
				�ſ뱸��
			</c:otherwise>
		</c:choose>
		
		</td>
	
	</tr>
	<tr>
		<td width="200" height="50">�������̸�</td>
		<td>${purchase.receiverName}</td>

	</tr>
	<tr>
		<td width="200" height="50">�����ڿ���ó</td>
		<td>${purchase.receiverPhone}</td>

	</tr>
	<tr>
		<td width="200" height="50">�������ּ�</td>
		<td width="500" >${purchase.divyAddr}</td>

	</tr>
		<tr>
		<td width="200" height="50">���ſ�û����</td>
		<td>${purchase.divyRequest}</td>

	</tr>
	<tr>
		<td width="200" height="50">����������</td>
		<td>${purchase.divyDate}</td>
	</tr>
</table>


</form>

</body>
</html>