import psycopg2
import json
import re 
import sqlite3
import datetime
import json
import argparse
import sys

def start_init(file):
  listOfjson = readjson(file)
  for x in listOfjson:
    if("open" in x):
      arg = x["open"]
      open_init(arg["database"],arg["login"],arg["password"])
    elif("leader" in x):
      arg = x["leader"]
      leader(arg["timestamp"],arg["password"], arg["member"])
    else:
      statusER()
      
def start_app(file):
  listOfjson = readjson(file)
  for x in listOfjson:
    if("open" in x):
      arg = x["open"]
      open_app(arg["database"],arg["login"],arg["password"])
    elif("protest" in x):
      arg = x["protest"]
      if "authority" in arg:
        protest(arg["timestamp"], arg["member"], arg["password"], arg["action"], arg["project"], arg["authority"])
      else:
        protest(arg["timestamp"], arg["member"], arg["password"], arg["action"], arg["project"])
    elif("support" in x):
      arg = x["support"]
      if "authority" in arg:
        support(arg["timestamp"], arg["member"], arg["password"], arg["action"], arg["project"], arg["authority"])
      else:
        support(arg["timestamp"], arg["member"], arg["password"], arg["action"], arg["project"])
    elif("upvote" in x):
      arg = x["upvote"]
      upvote(arg["timestamp"], arg["member"], arg["password"], arg["action"])
    elif("downvote" in x):
      arg = x["downvote"]
      downvote(arg["timestamp"], arg["member"], arg["password"], arg["action"])
    elif("actions" in x):
      arg = x["actions"]
      if "type" in arg:
        if "project" in arg:
          actions(arg["timestamp"], arg["member"], arg["password"], arg["type"], arg["project"])
        elif "authority" in arg:
          actions(arg["timestamp"], arg["member"], arg["password"], arg["type"], arg["authority"])
        else:
          actions(arg["timestamp"], arg["member"], arg["password"], arg["type"])
      elif "project" in arg:
        actions(arg["timestamp"], arg["member"], arg["password"], arg["project"])
      elif "authority" in arg:
        actions(arg["timestamp"], arg["member"], arg["password"], arg["authority"])
      else:
        actions(arg["timestamp"], arg["member"], arg["password"])
    elif("projects" in x):
      arg = x["projects"]
      if "authority" in arg:
        projects(arg["timestamp"], arg["member"], arg["password"], arg["authority"])
      else: 
        projects(arg["timestamp"], arg["member"], arg["password"])
    elif("votes" in x):
      arg = x["votes"]
      if "action" in arg:
        votes(arg["timestamp"], arg["member"], arg["password"], arg["action"])
      elif "project" in arg:
        votes(arg["timestamp"], arg["member"], arg["password"], arg["project"])
      else:
        votes(arg["timestamp"], arg["member"], arg["password"])
    elif("trolls" in x):
      arg = x["trolls"]
      trolls(arg["timestamp"])
    else:
      statusER()

def readjson(file):
  with open(file, 'r') as testFile:
    jsonLines = [line.strip() for line in testFile.readlines()]
    jsonObjects = [json.loads(line) for line in jsonLines]
  return jsonObjects

def reset():
  global conn
  conn = psycopg2.connect("dbname='student' user='init' password='qwerty' host='localhost'")
  global cur
  cur = conn.cursor()
  cur.execute("drop table Vote;")
  cur.execute("drop table Actions;")
  cur.execute("drop table Users;")
  cur.execute("drop table Project;")
  cur.execute("drop table ALL_ID;")
  cur.execute("REVOKE ALL PRIVILEGES ON DATABASE student FROM app;")
  cur.execute("DROP ROLE app")
  conn.commit()


def statusOK():
  print('{"status": "OK"}')

def status():
  print('{"status": "OK", \n "data": [' + str(',\n          '.join(str(e) for e in [list(x) for x in cur.fetchall()])) + ']\n}')
  
def statusER():
  print('{"status": "ERROR"}')

  
def not_exist_id(number, table, conn, cur):
  cur.execute("SELECT count(id) FROM %s WHERE id=%d;" %(table, number))
  if cur.fetchmany(1)[0][0] == 0:
    return 1
  return 0

def not_lead(member):
  cur.execute("SELECT is_lead FROM Users WHERE id=%d;" %member)
  if cur.fetchmany(1)[0][0]==0:
    return 1
  return 0

def validate_password_and_active(timestamp, member, password):
  cur.execute("SELECT count(id) FROM Users WHERE id=%d AND password=crypt('%s', password);" %(member, password))
  if cur.fetchmany(1)[0][0]==0:
      return 1
  cur.execute("SELECT last_activity FROM Users WHERE id=%d;" %member)
  if (timestamp - cur.fetchmany(1)[0][0]) >= 31536000:
      return 1
  return 0

def open_init(database, login, password):
  try:
    if login != "init":
      return statusER()
    global conn 
    conn = psycopg2.connect("dbname=%s user=%s password=%s host='localhost'" %(database, login, password))
    global cur 
    cur = conn.cursor()
    sql_file = open('/Users/iza/Desktop/baza.sql', 'r')
    cur.execute(sql_file.read())
    cur.execute("CREATE ROLE app WITH ENCRYPTED PASSWORD 'qwerty';")
    cur.execute("ALTER ROLE app WITH LOGIN;")
    cur.execute("GRANT CONNECT ON DATABASE %s TO app;" %database)
    cur.execute("GRANT INSERT, UPDATE, SELECT ON Users, ALL_ID, Actions, Vote, Project TO app;")
    conn.commit()
    return statusOK()
  except:
    return statusER()

def open_app(database, login, password):
  try:
    if login != "app":
      return statusER()
    global conn 
    conn = psycopg2.connect("dbname=%s user=%s password=%s host='localhost'" %(database, login, password))
    global cur
    cur = conn.cursor()
    conn.commit()
    return statusOK()
  except:
    return statusER()


def leader(timestamp, password, member):
  try:
    cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %member)
    cur.execute("INSERT INTO Users(id, password, last_activity, is_lead, upvotes, downvotes, active) VALUES(%d, crypt('%s', gen_salt('md5')), %d, 1, 0, 0, true);" %(member, password, timestamp))
    conn.commit()
    return statusOK()
  except:
    conn.rollback()
    return statusER()

  
def support(timestamp, member, password, action, project, *authority):
  try:
    if not_exist_id(member, 'Users', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %member)
      cur.execute("INSERT INTO Users(id, password, last_activity, is_lead, upvotes, downvotes, active) VALUES(%d, crypt('%s', gen_salt('md5')), %d, 0, 0, 0, true);" %(member, password, timestamp))
    else:
      if validate_password_and_active(timestamp, member, password):
          return statusER()
    if not_exist_id(project, 'Project', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %project)
      cur.execute("SELECT count(authority) FROM Project WHERE authority=%d;" %authority[0])
      if cur.fetchmany(1)[0][0]==0:
        cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %authority)
      cur.execute("INSERT INTO Project VALUES(%d, %d);" %(project, authority[0]))
    cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %action)
    cur.execute("INSERT INTO Actions VALUES(%d, %d, 0, 0, 'support', %d);" %(action, project, member))
    cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    cur.execute("UPDATE Users SET last_activity = %d WHERE id=%d;" %(timestamp, member))
    conn.commit()
    return statusOK()
  except:
    conn.rollback()
    return statusER()


def protest(timestamp, member, password, action, project, *authority):
  try:
    if not_exist_id(member, 'Users', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %member)
      cur.execute("INSERT INTO Users(id, password, last_activity, is_lead, upvotes, downvotes, active) VALUES(%d, crypt('%s', gen_salt('md5')), %d, 0, 0, 0, true);" %(member, password, timestamp))
    else:
      if validate_password_and_active(timestamp, member, password):
          return statusER()
    if not_exist_id(project, 'Project', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %project)
      cur.execute("SELECT count(authority) FROM Project WHERE authority=%d;" %authority[0])
      if  cur.fetchmany(1)[0][0]==0:    
        cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %authority)
      cur.execute("INSERT INTO Project VALUES(%d, %d);" %(project, authority[0]))
    cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %action)
    cur.execute("INSERT INTO Actions VALUES(%d, %d, 0, 0, 'protest', %d);" %(action, project, member))
    cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    cur.execute("UPDATE Users SET last_activity = %d WHERE id=%d;" %(timestamp, member))
    conn.commit()
    return statusOK()
  except:
    conn.rollback()
    return statusER()


def upvote(timestamp, member, password, action):
  try:
    if not_exist_id(member, 'Users', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %member)
      cur.execute("INSERT INTO Users(id, password, last_activity, is_lead, upvotes, downvotes, active) VALUES(%d, crypt('%s', gen_salt('md5')), %d, 0, 0, 0, true);" %(member, password, timestamp))
      cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    else:
      if validate_password_and_active(timestamp, member, password):
          return statusER()
    if not_exist_id(action, 'Actions', conn, cur):
        return statusER()
    cur.execute("SELECT count(userid) FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if  cur.fetchmany(1)[0][0]==0:    
        cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    cur.execute("SELECT upvotes FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if cur.fetchmany(1)[0][0]!=0:    
        return statusER()
    cur.execute("SELECT downvotes FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if cur.fetchmany(1)[0][0]!=0:    
        return statusER()
    cur.execute("UPDATE Users SET upvotes = upvotes+1, last_activity = %d WHERE id=%d;" %(timestamp, member))
    cur.execute("UPDATE Vote SET upvotes = 1 WHERE userid=%d and actionID=%d;" %(member, action))
    cur.execute("UPDATE Actions SET upvotes = upvotes + 1 WHERE id=%d;" %action)
    conn.commit()
    return statusOK()
  except:
    conn.rollback()
    return statusER()    

def downvote(timestamp, member, password, action):
  try:
    if not_exist_id(member, 'Users', conn, cur):
      cur.execute("INSERT INTO ALL_ID(id) VALUES(%d);" %member)
      cur.execute("INSERT INTO Users(id, password, last_activity, is_lead, upvotes, downvotes, active) VALUES(%d, crypt('%s', gen_salt('md5')), %d, 0, 0, 0, true);" %(member, password, timestamp))
      cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    else:
      if validate_password_and_active(timestamp, member, password):
          return statusER()
    if not_exist_id(action, 'Actions', conn, cur):
        return statusER()
    cur.execute("SELECT count(actionID) FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if  cur.fetchmany(1)[0][0]==0:    
        cur.execute("INSERT INTO Vote VALUES(%d, %d, 0, 0);" %(member, action))
    cur.execute("SELECT upvotes FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if cur.fetchmany(1)[0][0]!=0:    
        return statusER()
    cur.execute("SELECT downvotes FROM Vote WHERE userid=%d and actionID=%d;" %(member, action))
    if cur.fetchmany(1)[0][0]!=0:    
        return statusER()
    cur.execute("UPDATE Users SET downvotes = downvotes+1, last_activity = %d WHERE id=%d;" %(timestamp, member))
    cur.execute("UPDATE Vote SET downvotes = 1 WHERE userid=%d and actionID=%d;" %(member, action))
    cur.execute("UPDATE Actions SET downvotes = downvotes + 1 WHERE id=%d;" %action)
    conn.commit()
    return statusOK()
  except:
    conn.rollback()
    return statusER()
    
    
def actions(timestamp, member, password, *opcional):
  try:
    if not_exist_id(member, 'Users', conn, cur):
        return statusER()
    cur.execute("SELECT password FROM Users WHERE id=%d;" %member)
    if validate_password_and_active(timestamp, member, password):
        return statusER()
    if not_lead(member):
        return statusER()
    cur.execute("UPDATE Users SET last_activity = %d WHERE id=%d;" %(timestamp, member))
    if len(opcional)==2:
        if not_exist_id(opcional[1], 'Project', conn, cur):
          cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id WHERE typ='%s' and authority=%d ORDER BY Actions.id;" %(opcional[0], opcional[1]))
        else:
          cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id WHERE typ='%s' and Project.id=%d ORDER BY Actions.id;" %(opcional[0], opcional[1]))
    elif len(opcional)==1:
        if type(opcional[0]) == int:
          if not_exist_id(opcional[0], 'Project', conn, cur):
            cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id WHERE authority=%d ORDER BY Actions.id;" %(opcional[0]))
          else:
             cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id WHERE Project.id=%d ORDER BY Actions.id;" %(opcional[0]))
        else:
             cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id WHERE typ='%s' ORDER BY Actions.id;" %(opcional[0]))
    else:
         cur.execute("SELECT Actions.id, typ, Project.id, Project.authority, upvotes, downvotes FROM Actions JOIN Project ON Actions.projectid = Project.id ORDER BY Actions.id;" )
    conn.commit()
    return status()
  except:
    conn.rollback()
    return statusER()

    
def projects(timestamp, member, password, *authority):
  try:
    if not_exist_id(member, 'Users', conn, cur):
        return statusER()
    if validate_password_and_active(timestamp, member, password):
        return statusER()
    if not_lead(member):
        return statusER()
    cur.execute("UPDATE Users SET last_activity = %d WHERE id=%d;" %(timestamp, member))
    if len(authority) == 1:
        cur.execute("SELECT count(id) FROM Project WHERE authority=%d;" %authority[0])
        if  cur.fetchmany(1)[0][0]==0:  
          return statusER()  
        cur.execute("SELECT id, authority FROM Project WHERE authority=%d ORDER BY id;" %authority[0])
    else:
        cur.execute("SELECT id, authority FROM Project ORDER BY id;")
    conn.commit()
    return status()
  except:
    conn.rollback()
    return statusER()

def votes(timestamp, member, password, *opcional):
    try:
      if not_exist_id(member, 'Users', conn, cur):
          return statusER()
      cur.execute("SELECT password FROM Users WHERE id=%d;" %member)
      if validate_password_and_active(timestamp, member, password):
          return statusER()
      cur.execute("SELECT is_lead FROM Users WHERE id=%d;" %member)
      if not_lead(member):          
          return statusER()
      cur.execute("UPDATE Users SET last_activity = %d WHERE id=%d;" %(timestamp, member))
      if len(opcional) == 1:
          if not_exist_id(opcional[0], 'Project', conn, cur):
            cur.execute("SELECT count(id) FROM Actions WHERE id=%d;" %opcional[0])
            if cur.fetchmany(1)[0][0]==0:
              return statusER()
            cur.execute("SELECT userid, upvotes, downvotes FROM Vote WHERE actionID=%d UNION Select id, 0, 0 FROM Users JOIN Vote ON (Users.id= Vote.userid) WHERE  Vote.upvotes=0 and Vote.downvotes=0 and actionID=%d UNION SELECT id, 0, 0 FROM Users WHERE  Users.id NOT IN(Select userid FROM Vote WHERE actionID=%d) ORDER BY userid; " %(opcional[0], opcional[0], opcional[0]))
          else:
            cur.execute("SELECT Vote.userid, sum(Vote.upvotes), sum(Vote.downvotes) FROM Vote JOIN Actions ON (Actions.id=Vote.actionID) WHERE projectid=%d GROUP BY Vote.userid UNION SELECT id, 0, 0 FROM Users WHERE  Users.id NOT IN(Select Vote.userid FROM Vote JOIN Actions ON (Actions.id=Vote.actionID) WHERE projectid=%d) ORDER BY userid;" %(opcional[0], opcional[0]))
      else:
          cur.execute("SELECT id, upvotes, downvotes FROM Users ORDER BY id;")
      conn.commit()
      return status()
    except:
      conn.rollback()
      return statusER()

  
def trolls(timestamp):
  try:
    cur.execute("UPDATE Users SET active = false WHERE %d - last_activity >= 31536000;" %timestamp)
    cur.execute("SELECT userid, sum(Actions.upvotes), sum(Actions.downvotes), Users.active FROM Actions  JOIN Users ON(Users.id=Actions.userid) GROUP BY (userid,Users.active) HAVING sum(Actions.upvotes) < sum(Actions.downvotes)ORDER BY userid;")
    conn.commit()
    return status()
  except:
    conn.rollback()
    return statusER()
  


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('file')
  parser.add_argument("--init", action='store_true')
  parser.add_argument("--reset", action='store_true')
  args = parser.parse_args()
  
  if args.init:
    start_init(args.file)
  elif args.reset:
    reset()
  else:
    start_app(args.file)


if __name__ == '__main__':
    main()



try:
  cur.close()
  conn.close()
except:
  pass

