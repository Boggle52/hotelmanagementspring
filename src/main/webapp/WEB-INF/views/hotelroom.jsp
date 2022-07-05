<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="path" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link href="${path}/resources/css/hotelstyle.css" rel="stylesheet"/> 
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
</head>
<body>
    <br>&nbsp;&nbsp;&nbsp;&nbsp;<a href="hotelreservation">예약관리</a> <a href="hotelroom">객실관리</a>
    <table id="base2">
        <tr>
            <td id="border">
                <table id="inner">
                    <tr><td>객실목록</td></tr>
                    <tr><td><select size="20" class="form-select" id="roomlist">
                    </select></td></tr>
                </table>
            </td>
            <td id="border">
                <table id="inner">
                    <tr><td id="right">객실명&nbsp;</td><td><input type="text" id="roomname">&nbsp;&nbsp;&nbsp;</td></tr>
                    <tr><td id="right">객실종류&nbsp;</td>
                    <td><select id="roomtype"></select>&nbsp;&nbsp;&nbsp;</td></tr>
                    <tr><td id="right">숙박가능인원&nbsp;</td><td><input type="number" id="person">명</td></tr>
                    <tr><td id="right">1박요금&nbsp;</td><td><input type="number" id="price">원</td></tr>
                    <tr><td colspan="2" id="button"><input type="button" value="등록" id="btnAdd" class="btn btn-secondary">&nbsp;
                    <input type="button" value="삭제" id="btnDelete" class="btn btn-secondary">&nbsp;
                    <input type="button" value="비우기" id="btnRemove" class="btn btn-secondary">
                    <input type="hidden" id="optype" value="add"></td></tr>
                </table>
            </td>
        </tr>
    </table>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
</body>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
<script>
$(document)
.ready(function(){
	loadData()
	loadTypeData()
})
.on('click','#btnAdd',function(){
	if($('#roomname').val()==''||$('roomtype').val()==''||$('#person').val()==''||$('#price').val()==''){
		alert('값을 입력하십시오.')
	} else if($('#optype').val()=='add'){
		$.ajax({
			type:'get',url:'insertroom',
			data:{roomname:$('#roomname').val(),typenum:$('#roomtype option:selected').val(),
				person:$('#person').val(),price:$('#price').val()},
			dataType:'text',
			success:function(data){
				loadData()
			}
		})
	} else {
		$.ajax({
			type:'get',url:'updateroom',dataType:'text',
			data:{roomnum:$('#roomlist option:selected').val(),
				roomname:$('#roomname').val(),typenum:$('#roomtype option:selected').val(),
				person:$('#person').val(),price:$('#price').val()},
			success:function(data){
				loadData()
			}
		})
	}
	
})
.on('click','#btnDelete',function(){
	roomnum = $('#roomlist option:selected').val();
	$.ajax({
		type:'get',url:'deleteroom',data:'roomnum='+roomnum,dataType:'text',
		success:function(data){
			console.log(data)
			let check = data
			if(check=='false'){
				alert('이미 예약된 방은 삭제할 수 없습니다.')
			}
			loadData()
		}
	})
})
.on('click','#btnRemove',function(){
	/* $('#roomname,#person,#price').val('')
	$('#roomtype').val(1).prop("selected",true)
	$('#optype').val('add')
	$('#btnAdd').val('등록') */
	loadData()
})
.on('click','#roomlist option',function(){
	str = $(this).text()
	arr = str.split(", ")
	$('#roomname').val(arr[0])
	for(i=0;i<$('#roomtype option').length;i++){
		if($('#roomtype option:eq('+i+')').text()==arr[1]){
			$('#roomtype option:eq('+i+')').prop("selected",true)
		}
	}
	$('#person').val(arr[2])
	$('#price').val(arr[3])
	$('#optype').val('update')
	$('#btnAdd').val('수정')
})
function loadData(){
	$.ajax({
		type:'get',url:'selectroom',dataType:'json',
		success:function(data){
			$('#roomlist').empty();
			for(i=0; i<data.length; i++){
				let jo = data[i]
				let str = '<option value='+jo['roomnum']+'>'+jo['roomname']+", "+jo['roomtype']+", "
					+jo['person']+", "+jo['price']+'</option>'
				$('#roomlist').append(str)
			}
			$('#roomname,#roomtype,#person,#price').val('')
			$('#optype').val('add')
			$('#btnAdd').val('등록')
		}
	})
}
function loadTypeData(){
	$.ajax({
		type:'get',url:'typelist',dataType:'json',
		success:function(data){
			$('#roomtype').empty();
			$('#roomtype').append('<option value=1 hidden selected></option>')
			for(i=0;i<data.length;i++){
				let jo = data[i];
				let str = '<option value='+jo['typenum']+'>'+jo['roomtype']+'</option>'
				$('#roomtype').append(str)
			}
			$('#roomtype').val(1).prop("selected",true)
		}
	})
}
</script>
</html>