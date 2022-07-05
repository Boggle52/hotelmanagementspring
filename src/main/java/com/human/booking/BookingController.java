package com.human.booking;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class BookingController {
	
	@Autowired
	private SqlSession sqlSession;
	
	@RequestMapping("/hotelroom")
	public String doHotelRoom() {
		return "hotelroom";
	}
	
	@RequestMapping("/hotelreservation")
	public String doHotelReservation() {
		return "hotelreservation";
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/selectroom", produces = "application/text; charset=UTF-8")
	public String doSelectRoom(HttpServletRequest request) {
		iRoom room = sqlSession.getMapper(iRoom.class);
		ArrayList<hotelroomDTO> list = room.listRoom();
		JSONArray ja = new JSONArray();
		for(int i = 0; i<list.size(); i++) {
			hotelroomDTO hDto = new hotelroomDTO();
			hDto = list.get(i);
			JSONObject jo = new JSONObject();
			jo.put("roomnum",hDto.getRoomnum());
			jo.put("roomname",hDto.getRoomname());
			jo.put("roomtype",hDto.getRoomtype());
			jo.put("person",hDto.getPerson());
			jo.put("price",hDto.getPrice());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/insertroom", produces = "application/text; charset=UTF-8")
	public String doInsertRoom(HttpServletRequest request) {
		String roomname = request.getParameter("roomname");
		int typenum = Integer.parseInt(request.getParameter("typenum"));
		int person = Integer.parseInt(request.getParameter("person"));
		int price = Integer.parseInt(request.getParameter("price"));
		iRoom room = sqlSession.getMapper(iRoom.class);
		room.addnewRoom(roomname, typenum, person, price);
		return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteroom", produces = "application/text; charset=UTF-8")
	public String doDeleteRoom(HttpServletRequest request) {
		int roomnum = Integer.parseInt(request.getParameter("roomnum"));
		iRoom room = sqlSession.getMapper(iRoom.class);
		String data = "";
		try {
			room.deleteRoom(roomnum);
			data = "true";
			
		} catch (Exception e) {
			e.printStackTrace();
			data = "false";
		}
		return data;
	}
	
	@ResponseBody
	@RequestMapping(value = "/updateroom", produces = "application/text; charset=UTF-8")
	public String doUpdateRoom(HttpServletRequest request) {
		int roomnum = Integer.parseInt(request.getParameter("roomnum"));
		String roomname = request.getParameter("roomname");
		int typenum = Integer.parseInt(request.getParameter("typenum"));
		int person = Integer.parseInt(request.getParameter("person"));
		int price = Integer.parseInt(request.getParameter("price"));
		iRoom room = sqlSession.getMapper(iRoom.class);
		room.updateRoom(roomnum, roomname, typenum, person, price);
		return "0";
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/typelist", produces = "application/text; charset=UTF-8")
	public String doTypeList(HttpServletRequest request) {
		iRoom room = sqlSession.getMapper(iRoom.class);
		ArrayList<typelistDTO> list = room.listType();
		JSONArray ja = new JSONArray();
		for(int i=0; i<list.size(); i++) {
			typelistDTO tDto = new typelistDTO();
			tDto = list.get(i);
			JSONObject jo = new JSONObject();
			jo.put("typenum",tDto.getTypenum());
			jo.put("roomtype",tDto.getRoomtype());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/selectbook", produces = "application/text; charset=UTF-8")
	public String doSelectBook(HttpServletRequest request) {
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		int typenum = Integer.parseInt(request.getParameter("typenum"));
		String begindate = request.getParameter("begindate");
		String enddate = request.getParameter("enddate");
		ArrayList<hotelreservationDTO> list = reserv.selectBook(typenum, begindate, enddate);
		JSONArray ja = new JSONArray();
		for(int i=0; i<list.size(); i++) {
			hotelreservationDTO hDto2 = new hotelreservationDTO();
			hDto2 = list.get(i);
			JSONObject jo = new JSONObject();
			jo.put("booknum",hDto2.getBooknum());
			jo.put("roomname",hDto2.getRoomname());
			jo.put("begindate",hDto2.getBegindate());
			jo.put("enddate",hDto2.getEnddate());
			jo.put("name",hDto2.getName());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/selectavail", produces = "application/text; charset=UTF-8")
	public String doSelectAvail(HttpServletRequest request) {
		int typenum = Integer.parseInt(request.getParameter("typenum"));
		int person = Integer.parseInt(request.getParameter("person"));
		String begindate = request.getParameter("begindate");
		String enddate = request.getParameter("enddate");
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		ArrayList<hotelreservationDTO> list = reserv.availRoom(typenum, person, begindate, enddate);
		JSONArray ja = new JSONArray();
		for(int i=0; i<list.size(); i++) {
			hotelreservationDTO hDto2 = new hotelreservationDTO();
			hDto2 = list.get(i);
			JSONObject jo = new JSONObject();
			jo.put("booknum",hDto2.getBooknum());
			jo.put("roomnum",hDto2.getRoomnum());
			jo.put("roomname",hDto2.getRoomname());
			jo.put("roomtype",hDto2.getRoomtype());
			jo.put("person",hDto2.getPerson());
			jo.put("price",hDto2.getPrice());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value = "/insertbook", produces = "application/text; charset=UTF-8")
	public String doInsertBook(HttpServletRequest request) {
		int roomnum = Integer.parseInt(request.getParameter("roomnum"));
		int person = Integer.parseInt(request.getParameter("person"));
		String begindate = request.getParameter("begindate");
		String enddate = request.getParameter("enddate");
		String name = request.getParameter("name");
		int mobile = Integer.parseInt(request.getParameter("mobile"));
		int total = Integer.parseInt(request.getParameter("total"));
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		reserv.insertbook(roomnum, person, begindate, enddate, name, mobile, total);
		return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/updatebook", produces = "application/text; charset=UTF-8")
	public String doUpdateBook(HttpServletRequest request) {
		int booknum = Integer.parseInt(request.getParameter("booknum"));
		int person = Integer.parseInt(request.getParameter("person"));
		String name = request.getParameter("name");
		int mobile = Integer.parseInt(request.getParameter("mobile")); 
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		reserv.updatebook(booknum, person, name, mobile);
		return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/deletebook", produces = "application/text; charset=UTF-8")
	public String doDeleteBook(HttpServletRequest request) {
		int booknum = Integer.parseInt(request.getParameter("booknum"));
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		reserv.deletebook(booknum);
		return "0";
	}
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value = "/selectdetail", produces = "application/text; charset=UTF-8")
	public String doSelectDetail(HttpServletRequest request) {
		int booknum = Integer.parseInt(request.getParameter("booknum"));
		iReserv reserv = sqlSession.getMapper(iReserv.class);
		ArrayList<hotelreservationDTO> list = reserv.selectdetail(booknum);
		JSONArray ja = new JSONArray();
		for(int i=0; i<list.size(); i++) {
				hotelreservationDTO hDto = new hotelreservationDTO();
				hDto = list.get(i);
				JSONObject jo = new JSONObject();
				jo.put("roomname",hDto.getRoomname());
				jo.put("roomtype",hDto.getRoomtype());
				jo.put("person",hDto.getPerson());
				jo.put("begindate",hDto.getBegindate());
				jo.put("enddate",hDto.getEnddate());
				jo.put("name",hDto.getName());
				jo.put("mobile",hDto.getMobile());
				jo.put("total",hDto.getTotal());
				jo.put("availperson",hDto.getAvailperson());
				ja.add(jo);
		}
		return ja.toJSONString();
	}
	
}
