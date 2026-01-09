from abc import ABC, abstractmethod

class Notification(ABC):
    @abstractmethod
    def send_notification(self):
        pass
    
class Email(Notification):
    def send_notification(self):
        print("Notify From Email...")
    
class Push(Notification):
    def send_notification(self):
        print("Notify From Push...")
    
class SMS(Notification):
    def send_notification(self):
        print("Notify From SMS...")
    
class NotificationService:
    def __init__(self, notify_service):
        self.notify_service = notify_service
        
    def set_strategy(self, notify_service):
        self.notify_service = notify_service
        
    def call_service(self):
        self.notify_service.send_notification()
        
email = Email()
notify = NotificationService(email)
notify.call_service()

push = Push()
notify.set_strategy(push)
notify.call_service()