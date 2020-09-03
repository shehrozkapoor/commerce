from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    pass

class Catagories(models.Model):
    catagory = models.CharField(max_length=50)
    def __str__(self):
        return f"{self.catagory}"

class Auctions(models.Model):
    title = models.CharField(max_length=25)
    description = models.TextField()
    url = models.URLField()
    Catagory = models.CharField(max_length=50,null=True)
    owner = models.ForeignKey(User,on_delete=models.CASCADE,default=None,related_name="owner")
    
    def __str__(self):
        return f"{self.id} title: {self.title} description: {self.description} owner: {self.owner} {self.Catagory} "


class Bids(models.Model):
    item_id = models.ForeignKey(Auctions,on_delete=models.CASCADE,default=None,related_name="itemid")
    user = models.ForeignKey(User,on_delete=models.CASCADE,default=None,related_name="currentuser")
    bid = models.IntegerField()

    def __str__(self):
        return f"{self.item_id}"
class Closed_auctions(models.Model):
    auction = models.ForeignKey(Auctions,on_delete=models.CASCADE,null=True)
    username = models.CharField(max_length=25,null=True) 
    bid = models.IntegerField(null=True)
    def __str__(self):
        return f"{self.auction} username: {self.username} bid: {self.bid} "
class comments(models.Model):
    comment = models.TextField()
    auction = models.ForeignKey(Auctions,null=True,on_delete=models.CASCADE)
    def __str__(self):
        return f"{self.comment}"

class WatchList(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE,related_name="user_w")
    item_id = models.ForeignKey(Bids,on_delete=models.CASCADE,related_name="Auctions_w")
    
    def __str__(self):
        return f"{self.user} {self.item_id}"