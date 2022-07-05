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
    <table id="base">
        <tr>
            <td id="border">
                <table id="inner">
                    <tr><td id="right">숙박기간</td><td id="left">&nbsp;&nbsp;<input type="date" id=begindate>~<input type="date" id=enddate></td></tr>
                    <tr><td id="right">숙박인원</td><td id="left">&nbsp;&nbsp;<input type="number" id=person>명</td></tr>
                    <tr><td id="right">객실종류</td><td id="left">&nbsp;&nbsp;<select id=roomtype></select></td></tr>
                    <tr><td colspan="2" id="button"><input type="button" value="찾기" class="btn btn-secondary" id=find></td></tr>
                    <tr><td colspan="2" id="left">&nbsp;예약가능객실</td></tr>
                    <tr><td colspan="2" id="top">
                    <input type=hidden id='_typenum'>
                    <select size="17" class="form-select" id=availroom></select></td></tr>
                </table>
            </td>
            <td id="border">
                <table id="inner">
                    <tr><td id="right">예약번호</td><td><input type="number" id=_booknum readonly></td></tr>
                    <tr><td id="right">객실명</td><td><input type=text id=_roomname readonly></td></tr>
                    <tr><td id="right">객실종류</td><td><input type=text id=_roomtype readonly></td></tr>
                    <tr><td id="right">숙박예정인원</td><td><input type="number" id=_person></td></tr>
                    <tr><td id="right">숙박기간</td><td><input type="date" id=_begindate readonly>~<input type="date" id=_enddate readonly></td></tr>
                    <tr><td id="right">예약자</td><td><input type="text" id=name></td></tr>
                    <tr><td id="right">모바일</td><td><input type="number" id=mobile placeholder='010 제외하고 입력'></td></tr>
                    <tr><td id="right">숙박총액</td><td><input type="number" id=total readonly></td></tr>
                    <tr><td colspan="2" id="button">
                    	<input type="hidden" id="optype" value="add">
                    	<input type="button" value="예약등록" class="btn btn-secondary" id=complete>
                    	&nbsp;<input type="button" value="예약취소" class="btn btn-secondary" id=cancel>
                    	&nbsp;<input type="button" value="비우기" class="btn btn-secondary" id=remove></td></tr>
                </table>
            </td>
            <td id="border">
                <table id="inner">
                    <tr><td>예약내역</td></tr>
                    <tr><td><select size="23" class="form-select" id=booked></select></td></tr>
                </table>
            </td>
        </tr>
    </table>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pprn3073KE6tl6bjs2QrFaJGz5/SUsLqktiwsUTF55Jfv3qYSDhgCecCxMW52nD2" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.js"></script>
<script>
$(document)
.ready(function(){
 	loadTypeData()
 	$('#person').change(function(){
 		if($('#person').val()<1){
 			alert('잘못 입력하셨습니다.')
 			$('#person').val('')
 		}
 	})
 	$('#_person').change(function(){
 		if($('#_person').val()<1){
 			alert('잘못 입력하셨습니다.')
 			$('#_person').val('')
 		}
 	})
 	$('#enddate').change(function(){
 		if($('#enddate').val()<=$('#begindate').val()){
 			alert('잘못 입력하셨습니다.')
 			$('#enddate').val('')
 		}
 	})
 	$('#_enddate').change(function(){
		if($('#_enddate').val()<=$('#_begindate').val()){
			alert('잘못 입력하셨습니다.')
			$('#_enddate').val('')
		}
 	})
 	$('#_person').change(function(){
 		if($('#_person').attr("placeholder")!=''){
 			let num = $('#_person').attr("placeholder").charAt(0)
 			parseInt(num)
 			if($('#_person').val()>num){
 				alert('잘못 입력하셨습니다.')
 				$('#_person').val('')
 			}
 		}
 	})
})
.on('click','#find',function(){
	if($('#begindate').val()==''||$('#enddate').val()==''||$('#person').val==''
			||$('#roomtype').val()==''){
		alert('값을 입력하세요.')
	}
	$.ajax({
		type:'get',url:'selectavail',dataType:'json',
		data:{begindate:$('#begindate').val(),enddate:$('#enddate').val(),
			person:$('#person').val(),typenum:$('#roomtype').val()},
		success:function(data){
			$('#availroom').empty();
			for(i=0; i<data.length; i++){
				let jo = data[i]
				let str = "<option value="+jo['roomnum']+">"+jo['roomname']+", "
					+jo['roomtype']+", "+jo['person']+"인"+", "+jo['price']+"원</option>"
				$('#availroom').append(str)
			}
			$('#_typenum').val($('#roomtype').val())
		}
	})
	$.ajax({
		type:'get',url:'selectbook',dataType:'json',
		data:{begindate:$('#begindate').val(),enddate:$('#enddate').val(),
			typenum:$('#roomtype option:selected').val()},
		success:function(data){
			$('#booked').empty();
			for(i=0; i<data.length; i++){
				let jo = data[i]
				let str = "<option value="+jo['booknum']+">"+jo['roomname']+", "
					+jo['begindate']+"~"+jo['enddate']+", "+jo['name']+"</option>"
				$('#booked').append(str)
			}
		}
	})
})
.on('click','#complete',function(){
	if($('#_person').val()==''||$('#name').val()==''||$('#mobile').val()==''){
		alert('값을 입력하십시오.')
	} else if($('#optype').val()=='add'){
		$.ajax({
			type:'get',url:'insertbook',dataType:'text',
			data:{roomnum:$('#availroom option:selected').val(),
				typenum:$('#_typenum').val(),person:$('#_person').val(),
				begindate:$('#_begindate').val(),enddate:$('#_enddate').val(),name:$('#name').val(),
				mobile:$('#mobile').val(),total:$('#total').val()},
			success:function(){
				$('#find').trigger('click')
				$('#remove').trigger('click')
			}
		})
	} else {
		$.ajax({
			type:'get',url:'updatebook',dataType:'json',
			data:{booknum:$('#_booknum').val(),person:$('#_person').val(),name:$('#name').val(),
				mobile:$('#mobile').val()},
		})
		$('#find').delay(500).trigger('click')
		$('#remove').trigger('click')
		$('#optype').val('add')
		$('#complete').val('예약추가')
		$('#_person').attr("placeholder",'')
	}
})
.on('click','#cancel',function(){
	$.ajax({
		type:'get',url:'deletebook',
		data:'booknum='+$('#booked option:selected').val(),
		success:function(data){
			$('#find').trigger('click')
			$('#remove').trigger('click')
		}
	})
})
.on('click','#remove',function(){
	$('#_booknum,#_roomname,#_roomtype,#_person,#_begindate,#_enddate,#name,#mobile,#total').val('')
	$('#optype').val('add')
	$('#complete').val('예약추가')
	$('#_person').attr("placeholder",'')
})
.on('click','#availroom option',function(){
	$('#_booknum').val('')
	$('#name').val('')
	$('#mobile').val('')
	$('#_begindate').val($('#begindate').val())
	$('#_enddate').val($('#enddate').val())
	$('#_person').val($('#person').val())
	arr = $('#availroom option:selected').text().split(", ")
	$('#_roomname').val(arr[0])
	$('#_roomtype').val(arr[1])
	$('#_person').val($('#person').val())
	let num = parseInt(arr[2].charAt(0))
	$('#_person').attr("placeholder",+num+"명 이하")
	begindate = new Date($('#begindate').val())
	enddate = new Date($('#enddate').val())
	let diff = Math.ceil((enddate - begindate)/(1000*3600*24))
	$('#total').val(parseInt(arr[3].slice(0,-1))*diff)
	
})
.on('click','#booked option',function(){
	 $.ajax({
		type:'get',url:'selectdetail',dataType:'json',
		data:'booknum='+$('#booked option:selected').val(),
		success:function(data){
			let jo = data[0]
			$('#_booknum').val($('#booked option:selected').val())
			$('#_roomname').val(jo['roomname'])
			$('#_roomtype').val(jo['roomtype'])
			$('#_person').val(jo['person'])
			$('#_begindate').val(jo['begindate'])
			$('#_enddate').val(jo['enddate'])
			$('#name').val(jo['name'])
			$('#mobile').val(jo['mobile'])
			$('#total').val(jo['total'])
			$('#_person').attr("placeholder",jo['availperson']+"명 이하")
			$('#optype').val('update')
			$('#complete').val('예약수정')
		} 
	})
})
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
			$('#optype').val('add')
			$('#complete').val('예약추가')
		}
	})
	/* $.ajax({
		type:'get',url:'availlist', dataType:'json',
		success:function(data){
			$('#availroom').empty();
			for(i=0; i<data.length; i++){
				let jo = data[i]
				let str = "<option>"+jo['roomname']+", "
					+jo['roomtype']+", "+jo['person']+"인"+", "+jo['price']+"원</option>"
				$('#availroom').append(str)
			}
		}
	}) */
}
/* function loadBookedData(){
	$.ajax({
		type:'get',url:'booklist',dataType:'json',
		success:function(data){
			$('#booked').empty();
			for(i=0; i<data.length; i++){
				let jo = data[i]
				let str = "<option value="+jo['booknum']+">"+jo['roomname']+", "
					+jo['begindate']+"~"+jo['enddate']+", "+jo['name']+"</option>"
				$('#booked').append(str)
			}
		}
	})
} */
</script>
</body>
</html>