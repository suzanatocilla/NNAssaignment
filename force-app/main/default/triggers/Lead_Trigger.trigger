trigger Lead_Trigger on Lead  (after update,after insert,before insert, before update) {
  System.debug('Enter Lead Trigger');
        new LeadTriggerHandler().run();
}