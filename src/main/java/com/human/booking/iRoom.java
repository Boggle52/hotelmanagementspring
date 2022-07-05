package com.human.booking;

import java.util.ArrayList;

public interface iRoom {
	ArrayList<hotelroomDTO> listRoom();
	void addnewRoom(String roomname, int typenum, int person, int price);
	boolean deleteRoom(int roomnum);
	void updateRoom(int roomnum, String roomname, int typenum, int person, int price);
	ArrayList<typelistDTO> listType();
}
