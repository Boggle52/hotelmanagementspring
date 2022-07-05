package com.human.booking;

import java.util.ArrayList;

public interface iReserv {
	ArrayList<hotelreservationDTO> availRoom(int typenum, int person, String begindate, String enddate);
	ArrayList<hotelreservationDTO> selectBook(int typenum, String begindate, String enddate);
	void insertbook(int roomnum, int person, String begindate, String enddate, 
			String name, int mobile, int total);
	void updatebook(int booknum, int person, String name, int mobile);
	void deletebook(int booknum);
	ArrayList<hotelreservationDTO> selectdetail(int data);
}
