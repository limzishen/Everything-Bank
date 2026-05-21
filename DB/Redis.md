Remote Dictionary Server 
Redis stores data in the RAM instead of hard disk 
When persistence is needed a snapshot of the ram is made and stored on the disk 
Redis is not the more durable (ex. power outages) causing ram data to be lost 
Redis take snapshot of the ram to create save points on the hard disk 
