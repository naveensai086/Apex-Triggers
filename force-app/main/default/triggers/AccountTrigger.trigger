trigger AccountTrigger on Account (after update) {
 if(Trigger.isUpdate && Trigger.isAfter){
    AccountTriggerHandler.updateContactsWithAccountPhone(Trigger.new,Trigger.oldMap);
 }

}