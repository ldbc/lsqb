import mgclient
from traceback import print_exc

con = mgclient.connect(host='127.0.0.1', port=27687)
con.autocommit = True;
cur = con.cursor()

try:
    cur.execute("CREATE INDEX ON :Message")
    cur.execute("CREATE INDEX ON :Comment")
    cur.execute("CREATE INDEX ON :Post")
    cur.execute("CREATE INDEX ON :Person")
    cur.execute("CREATE INDEX ON :Forum")
    cur.execute("CREATE INDEX ON :City")
    cur.execute("CREATE INDEX ON :Country")
    cur.execute("CREATE INDEX ON :Tag")
    cur.execute("CREATE INDEX ON :TagClass")
except mgclient.DatabaseError:
    print_exc()
