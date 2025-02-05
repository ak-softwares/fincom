import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TCloudHelperFunction extends GetxController{

  //Helper function to check the state of multiple (list) database recodes
  //Return a widget based on the state of the snapshot.
  //if data is still loading, it returns a circularProgressIndicator.
  //if no data is found, it returns a generic "No data found" message or a custom nothingFoundWidget if provided.
  //if an error occurs, it returns a generic error message.
  //Otherwise, it returns null

  static Widget? checkMultiRecodeState<T>({required AsyncSnapshot<List<T>> snapshot, Widget? loader, Widget? error, Widget? nothingFound}){
    if(snapshot.connectionState == ConnectionState.waiting){
      if(loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if(!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if(nothingFound != null) return nothingFound;
      return const SizedBox(height: 600, child: Text('No data available'));
    }

    if(snapshot.hasError) {
      if(error != null) return error;
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    return null;
  }

  static Widget? checkSingleRecordState<T>({required AsyncSnapshot<T> snapshot, Widget? loader, Widget? error, Widget? notFound}){
    if(snapshot.connectionState == ConnectionState.waiting){
      if(loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if(!snapshot.hasData || snapshot.data == null) {
      if(notFound != null) return notFound;
      return const SizedBox(height: 600, child: Text('No data available'));
    }

    if(snapshot.hasError) {
      if(error != null) return error;
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    return null;
  }

}