<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>

<% System.out.println("* [ listProduct.jsp ] "); %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	


<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

	// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
	function fncGetProductList(currentPage) {
		//document.getElementById("currentPage").value = currentPage;
		$("#currentPage").val(currentPage)
	   	//document.detailForm.submit();
		
		var menu = $("input[name='menu']").val();		
		$("form").attr("method" , "POST").attr("action" , "/product/listProduct?menu="+menu).submit();
	}
	
	 $(function() {
			 
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( "td.ct_btn01:contains('검색')" ).on("click" , function() {
				fncGetProductList(1);
			});
			
			$(".prodName").on("click" , function() {
				var prodNo = $(this).attr("data-prodNo")
				var menu = $(this).attr("data-menu")
				 
				//alert(  $( this ).text().trim() );
				if(menu == "manage"){
					self.location ="/product/updateProductView?prodNo="+prodNo+"&menu="+menu;
				}
				if(menu == "search"){
					self.location ="/product/getProduct?prodNo="+prodNo+"&menu="+menu;
				}
				
			});
			
			$("#ship").on("click" , function() {
				//Debug..
				//alert(  $( this ).text().trim() );
				self.location ="/purchase/updateTranCodeByProd?prodNo=" + $(this).attr("data-prodNo")+"&tranCode=" +$(this).attr("data-tranCode");
			}); 
			
			//==> DOM Object GET 3가지 방법 ==> 1. $(tagName) : 2.(#id) : 3.$(.className)
			$( ".ct_list_pop td:nth-child(3)" ).on("mouseover" , function() {
							
				var prodNo = $(this).attr("data-prodNo")
				$.ajax( 
						{
						url : "/product/json/getProduct/"+prodNo,
						method : "GET" ,
						dataType : "json" ,
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						success : function(JSONData , status) {

						//alert(status);
						//alert("JSONData : \n"+JSONData);
									
						var displayValue = "<h3>"
										+" 이&nbsp;&nbsp;름 : "+JSONData.prodName+"<br/>"
										+" 정&nbsp;&nbsp;보 : "+JSONData.prodDetail+"<br/>"
										+" 제조일 : "+JSONData.manuDate+"<br/>"
										+" 가&nbsp;&nbsp;격 : "+JSONData.price+"<br/>"
										+"</h3>";
									$("h3").remove();
									$( "#"+prodNo+"" ).html(displayValue);
						}
					});
						////////////////////////////////////////////////////////////////////////////////////////////
			});
					
			//==> userId LINK Event End User 에게 보일수 있도록 
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
			$("h7").css("color" , "red");
			
			//==> 아래와 같이 정의한 이유는 ??
			$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
		});	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">

	<%-- <form name="detailForm" action="/product/listProduct?menu=${menu}" method="post"> --%>
	<form name="detailForm">
	<input type="hidden" name="menu" value="${param.menu}">

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37"></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							
							<c:choose>
								<c:when test="${ empty param.menu || param.menu == 'manage'}"> 
									<td width="93%" class="ct_ttl01">상품 관리</td>
								</c:when>
								<c:otherwise>
									<td width="93%" class="ct_ttl01">상품 목록조회</td>
								</c:otherwise>
							</c:choose>

							</tr>

						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37"></td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="right"><select name="searchCondition"
						class="ct_input_g" style="width: 80px">
							<option value="0" ${search.searchCondition eq '0' ? "selected" : "" }>상품번호</option>
							<option value="1" ${search.searchCondition eq '1' ? "selected" : "" }>상품명</option>
							<option value="2" ${search.searchCondition eq '2' ? "selected" : "" }>가격</option>
					</select> 
					
						<input type="text" name="searchKeyword" 
						value="${! empty search.searchKeyword ? search.searchKeyword : ''}"  
						class="ct_input_g" style="width:200px; height:20px" > 
						
					
					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img
									src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01"
									style="padding-top: 3px;">
									
								<!-- <a href="javascript:fncGetProductList(1);">검색</a> -->
									검색
								</td>
								
								<td width="14" height="23"><img
									src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage }페이지
					</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="50">No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">상품명</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="80">가격</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="100">등록일</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">현재상태</td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>
			
	<c:set var="i" value="0" />
	<c:forEach var="product" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center">${ i }</td>
			<td></td>
			<td align="left" class="prodName" data-prodNo="${product.prodNo}" data-menu="${param.menu}" >${product.prodName}</td>
		
			<td></td>
			<td align="center">${product.price}</td>
			<td></td>
			<td align="center">${product.regDate}			
			<td></td>
			<td align="left">
						
			<c:choose>
				<c:when test="${ empty product.proTranCode || product.proTranCode == '0' }"> 
					판매중
				</c:when>				
				<c:when test="${ product.proTranCode == '1' }"> 
					<c:choose>
    					<c:when test="${ param.menu == 'manage' }"> 
    						<%-- 구매완료 <a href="/purchase/updateTranCodeByProd?prodNo=${product.prodNo }&tranCode=2">배송하기</a> --%>
    						구매완료&nbsp;&nbsp;&nbsp;
    						<span id="ship" data-prodNo="${product.prodNo}" data-tranCode="2"> [ 배송하기 : 여기를 누르세요 ]</span>
    					</c:when>
    					<c:otherwise> 
    						구매완료
    					</c:otherwise>
    				</c:choose>
				</c:when>
				<c:when test="${ product.proTranCode == '2' }"> 
					배송중
				</c:when>							
				<c:otherwise>
					배송완료
				</c:otherwise>
				</c:choose>		
						
			</td>		
		</tr>
		<tr>
			<!-- <td colspan="11" bgcolor="D6D7D6" height="1"></td> -->
			<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
	
		</tr>
	</c:forEach>
</table>

			<!-- PageNavigation Start... -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> 
												
						<jsp:include page="../common/pageNavigatorProduct.jsp"/>
					</td>
				</tr>
			</table>		
			<!-- PageNavigation End... -->
		</form>
	</div>

</body>
</html>