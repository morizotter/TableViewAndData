TableViewAndData
================

```
This is a sample to handle table view data. How do you think?
```

Why I make this sample?
---------------------------

How do you handle table view data? Before, I handle it with NSArray or NSMutableArray in the UIViewController's subclass. At that time, I made the contens of the array in it. Messy... And then, I split data from ViewController, it was OK. Now, I make the data store class for handling the section and row data. The good points are,

1. You can split model from view controller. ViewController becomes clean!
2. You can easily make many kinds of cells based on the row data class's information.
3. The data store class can cache the data.

But, I don't know more efficient way or pattern. If you know better idea. Please tell me!

Sample's explanation
---------------------

This sample is using twitter timeline. So, first, please tap the upper-left buttn and select twitter account. And then, the timeline will show. It is possible to do pull-to-refresh. 

In this sample twitter is not important. I just needed a set of data and wanted to use a simple networking.

Lisense
--------

I put MIT. but I don't know exactly it is. Please use as you like.

Author
-------

- Page: [http://moritanaoki.org](http://moritanaoki.org)
- Twitter: [@morizotter](http://twitter.com/morizotter)
- Facebook: [Don't hesitate to request.](http://facebook.com/morizotter)