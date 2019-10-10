



CREATE TABLE All_ID (id integer PRIMARY KEY NOT NULL);

CREATE TABLE Users(id integer NOT NULL PRIMARY KEY , password varchar(128) NOT NULL, last_activity integer NOT NULL, is_lead smallint NOT NULL, upvotes integer NOT NULL, downvotes integer NOT NULL, active bool NOT NULL, FOREIGN KEY (id) REFERENCES All_ID(id));

CREATE TABLE Project(id integer  NOT NULL PRIMARY KEY, authority integer  NOT NULL, FOREIGN KEY (id) REFERENCES All_ID(id), FOREIGN KEY (authority) REFERENCES All_ID(id));

CREATE TABLE Actions(id integer NOT NULL PRIMARY KEY, projectid integer  NOT NULL,  downvotes integer  NOT NULL, upvotes integer NOT NULL, typ varchar(10) NOT NULL, userid integer NOT NULL, FOREIGN KEY (id) REFERENCES All_ID(id), FOREIGN KEY (userid) REFERENCES Users(id), FOREIGN KEY (projectid) REFERENCES Project(id),  CONSTRAINT chk_typ CHECK (typ IN ('protest', 'support'))
);

CREATE TABLE Vote(userid integer  NOT NULL , actionID integer  NOT NULL, upvotes integer NOT NULL, downvotes integer NOT NULL, PRIMARY KEY(userid, actionid), FOREIGN KEY (userid) REFERENCES Users(id), FOREIGN KEY (actionid) REFERENCES Actions(id));


