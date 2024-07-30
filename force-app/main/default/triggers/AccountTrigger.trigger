trigger AccountTrigger on Account (after update,before update,after insert,before insert) {

 if(Trigger.isUpdate && Trigger.isAfter){
    AccountTriggerHandler.updateContactsWithAccountPhone(Trigger.new,Trigger.oldMap);
 }

    /*Trigger to create a related Contact of Account with same phone as Account's phone if custom 
   checkbox field on Account is checked. */

   if( Trigger.isAfter){
      if(Trigger.isInsert) 
      AccountTriggerHandler.createContactOnChecked(Trigger.new,null);
      if(Trigger.isUpdate) 
      AccountTriggerHandler.createContactOnChecked(Trigger.new,Trigger.oldMap);
    }


 if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
   AccountTriggerHandler.preventDuplicateRecord(Trigger.new);
 }


}