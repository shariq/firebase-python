#firebase-python
######A nice, easy Python Firebase integration

Supports streaming data.

Requires `requests` and `sseclient`, which are on pip. If you don't know what that is, don't worry; just run `./setup.sh`. Made for Python 2.7.

First create a Firebase here:
https://www.firebase.com/signup/

(warning: The free level of Firebase only allows up to 50 concurrent connections. Don't hit this limit!)



##get, put and push

`get` gets the value of a Firebase at some URL, `put` writes or replaces data at the path defined by URL and `push` appends data to a list at the path defined by URL. A new ID is also generated every time you `push` to a Firebase URL.

```python
>>> import firebase
>>> URL = 'lucid-lychee'  # see note on URLs at the bottom of documentation
>>> print firebase.get(URL)  # this is an empty Firebase
None

>>> firebase.put(URL, 'tell me everything')  # can take a string
>>> print firebase.get(URL)
tell me everything

>>> firebase.put(URL, {'lucidity': 9001})  # or a dictionary
>>> print firebase.get(URL)
{u'lucidity': 9001}

>>> firebase.put(URL, {'color': 'red'})  # replaces old value
>>> print firebase.get(URL)
{u'color': u'red'}

>>> print firebase.get(URL + '/color')
red

>>> #Whereas using put replaces existing data, push simply appends to a list
>>> firebase.push(URL+'/listexample',{'color':'red'})
>>> firebase.get(URL+'/listexample')
{'u'-JyAXHX9ZNBh7tPPja4w':{'color':'red'}}

>>> firebase.push(URL+'/listexample',{'color':'green'})
>>> firebase.get(URL+'/listexample')
{'u'-JyAXHX9ZNBh7tPPja4w':{'color':'red'},'-JyAXHX9ZNBh7tPPjasd':{'color':'green'}}
```



##patch

`patch` adds new key value pairs to an existing Firebase, without deleting the old key value pairs.

```python
>>> import firebase
>>> URL = 'tibetan-tumbleweed'
>>> print firebase.get(URL)
None

>>> firebase.patch(URL, {'taste': 'tibetan'})
>>> print firebase.get(URL)
{u'taste': u'tibetan'}

>>> firebase.patch(URL, {'size': 'tumbly})  # patching does not overwrite
>>> print firebase.get(URL)
{u'taste': u'tibetan', u'size': u'tumbly'}
```



##subscriber

`subscriber` takes a URL and callback function and calls the callback on every update of the Firebase at URL.

```python
>>> import firebase
>>> from pprint import pprint  # function which pretty prints objects
>>> URL = 'clumsy-clementine'
>>> S = firebase.subscriber(URL, pprint)  # pprint will be called on all Firebase updates
>>> S.start()  # will get called with initial value of URL, which is empty
(u'put', {u'data': None, u'path': u'/'})

>>> firebase.put(URL, ';-)')  # will make S print something
(u'put', {u'data': u';-)', u'path': u'/'})

>>> firebase.put(URL, {'status': 'mortified'})  # continuing from above
(u'put', {u'data': {u'status': u'mortified'}, u'path': u'/'})
>>> firebase.patch(URL, {'reason': 'blushing'})  # same data, different method
(u'patch', {u'data': {u'reason': u'blushing'}, u'path': u'/'})

>>> firebase.put(URL + '/color', 'red')
(u'put', {u'data': u'red', u'path': u'/color'})

>>> S.stop()
```



##URLs
All URLs are internally converted to the apparent Firebase URL. This is done by the `firebaseURL` method.

```python
>>> import firebase

>>> print firebase.firebaseURL('bony-badger')
https://bony-badger.firebaseio.com/.json

>>> print firebase.firebaseURL('bony-badger/bones/humerus')
https://bony-badger.firebaseio.com/bones/humerus.json

>>> print firebase.firebaseURL('bony-badger.firebaseio.com/')
https://bony-badger.firebaseio.com/.json
```
