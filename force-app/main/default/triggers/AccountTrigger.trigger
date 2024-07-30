trigger AccountTrigger on Account (after update,before update,before insert) {
 if(Trigger.isUpdate && Trigger.isAfter){
    AccountTriggerHandler.updateContactsWithAccountPhone(Trigger.new,Trigger.oldMap);
 }
 if((Trigger.isUpdate || Trigger.isInsert) && Trigger.isBefore){
   AccountTriggerHandler.preventDuplicateRecord(Trigger.new);
 }
}