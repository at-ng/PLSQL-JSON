CREATE OR REPLACE
TYPE BODY json_object IS

----------------------------------------------------------
--	json_object
--
CONSTRUCTOR FUNCTION json_object(SELF IN OUT NOCOPY json_object) RETURN SELF AS result
IS
BEGIN
	SELF.nodes	:=	json_nodes();
	SELF.lastID	:=	NULL;
	RETURN;
END json_object;

----------------------------------------------------------
--	json_object
--
CONSTRUCTOR FUNCTION json_object(SELF IN OUT NOCOPY json_object, theData IN json_value) RETURN SELF AS result
IS
BEGIN
	IF (theData.typ != json_const.NODE_TYPE_OBJECT) THEN
		raise_application_error(-20100, 'json_object exception: unable to convert node ('||theData.typ||') to an object');
	ELSE
		SELF.nodes	:=	theData.nodes;
		SELF.lastID	:=	NULL;
	END IF;
	RETURN;
END json_object;

----------------------------------------------------------
--	json_object
--
CONSTRUCTOR FUNCTION json_object(SELF IN OUT NOCOPY json_object, theJSONString IN CLOB) RETURN SELF AS result
IS
BEGIN
	SELF.nodes	:=	json_parser.parser(theJSONString);
	SELF.lastID	:=	NULL;
	RETURN;
END json_object;

----------------------------------------------------------
--	put
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName));
END put;

----------------------------------------------------------
--	put (VARCHAR2)
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN VARCHAR2)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName, theValue));
END put;

----------------------------------------------------------
--	put (CLOB)
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN CLOB)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName, theValue));
END put;

----------------------------------------------------------
--	put (NUMBER)
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN NUMBER)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName, theValue));
END put;

----------------------------------------------------------
--	put (DATE)
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN DATE)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName, theValue));
END put;

----------------------------------------------------------
--	put (BOOLEAN)
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN BOOLEAN)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	-- add the node
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theName, theValue));
END put;

----------------------------------------------------------
--	put
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN json_object)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	--	add a new object node that will be used as the root for all the sub notes
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(json_const.NODE_TYPE_OBJECT, theName, NULL, NULL, NULL, NULL, NULL, NULL, NULL));

	--	copy the sub-nodes
	json_utils.copyNodes(theTargetNodes=>SELF.nodes, theTargetNodeID=>aNodeID, theLastID=>SELF.lastID, theName=>theName, theSourceNodes=>theValue.nodes);
END put;

----------------------------------------------------------
--	put
--
MEMBER PROCEDURE put(SELF IN OUT NOCOPY json_object, theName IN VARCHAR2, theValue IN json_value)
IS
	aNodeID	BINARY_INTEGER := json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>theName);
BEGIN
	-- remove the existing node if we change an existing property
	IF (aNodeID IS NOT NULL) THEN
		SELF.lastID := json_utils.removeNode(theNodes=>SELF.nodes, theNodeID=>aNodeID);
	END IF;

	--	add a new object node that will be used as the root for all the sub notes
	aNodeID := json_utils.addNode(theNodes=>SELF.nodes, theLastID=>SELF.lastID, theNode=>json_node(theValue.typ, theName, NULL, NULL, NULL, NULL, NULL, NULL, NULL));

	--	copy the sub-nodes
	json_utils.copyNodes(theTargetNodes=>SELF.nodes, theTargetNodeID=>aNodeID, theLastID=>SELF.lastID, theName=>theName, theSourceNodes=>theValue.nodes);
END put;

----------------------------------------------------------
--	count
--
MEMBER FUNCTION count(SELF IN json_object) RETURN NUMBER
IS
BEGIN
	RETURN json_utils.getNodeCount(theNodes=>SELF.nodes);
END count;

----------------------------------------------------------
--	get
--
MEMBER FUNCTION get(SELF IN json_object, thePropertyName IN VARCHAR2) RETURN json_value
IS
	aNodeID	BINARY_INTEGER	:=	json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>thePropertyName);
BEGIN
	IF (aNodeID IS NOT NULL) THEN
		RETURN json_utils.createSubTree(theSourceNodes=>SELF.nodes, theSourceNodeID=>aNodeID);
	ELSE
		raise_application_error(-20100, 'json_object exception: property ('||thePropertyName||') does not exit');
		RETURN NULL;
	END IF;
END get;

----------------------------------------------------------
--	exist
--
MEMBER FUNCTION exist(SELF IN json_object, thePropertyName IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
	RETURN (json_utils.getNodeIDByName(theNodes=>SELF.nodes, thePropertyName=>thePropertyName) IS NOT NULL);
END exist;

----------------------------------------------------------
--	get_keys
--
MEMBER FUNCTION get_keys RETURN json_keys
IS
	keys	json_keys	:=	json_keys();
	i		BINARY_INTEGER	:=	SELF.nodes.FIRST;
BEGIN
	WHILE (i IS NOT NULL) LOOP
		keys.EXTEND(1);
		keys(keys.LAST) := SELF.nodes(i).nam;
		i := SELF.nodes(i).nex;
	END LOOP;

	RETURN keys;
END get_keys;

----------------------------------------------------------
--	to_json_value
--
MEMBER FUNCTION to_json_value(SELF IN json_object) RETURN json_value
IS
BEGIN
	RETURN json_value(json_const.NODE_TYPE_OBJECT, SELF.nodes);
END to_json_value;

----------------------------------------------------------
--	to_clob
--
MEMBER PROCEDURE to_clob(SELF IN json_object, theLobBuf IN OUT NOCOPY CLOB, theEraseLob BOOLEAN DEFAULT TRUE)
IS
	aStrBuf	VARCHAR2(32767);
BEGIN
	IF (theEraseLob) THEN
		json_clob.erase(theLobBuf);
	END IF;
	json_utils.object_to_clob(theLobBuf=>theLobBuf, theStrBuf=>aStrBuf, theNodes=>SELF.nodes, theNodeID=>SELF.nodes.FIRST);
END to_clob;

----------------------------------------------------------
--	to_text
--
MEMBER FUNCTION to_text(SELF IN json_object) RETURN VARCHAR2
IS
	aStrBuf	VARCHAR2(32767);
	aLobLoc	CLOB;
BEGIN
	dbms_lob.createtemporary(lob_loc=>aLobLoc, cache=>TRUE, dur=>dbms_lob.session);
	json_utils.object_to_clob(theLobBuf=>aLobLoc, theStrBuf=>aStrBuf, theNodes=>SELF.nodes, theNodeID=>SELF.nodes.FIRST);
	aStrBuf := dbms_lob.substr(aLobLoc, 32767, 1);
	dbms_lob.freetemporary(lob_loc=>aLobLoc);

	RETURN aStrBuf;
END to_text;

----------------------------------------------------------
--	htp
--
MEMBER PROCEDURE htp(SELF IN json_object, theJSONP IN VARCHAR2 DEFAULT NULL)
IS
	aLob	CLOB	:=	empty_clob();
BEGIN
	dbms_lob.createtemporary(aLob, TRUE);
	SELF.to_clob(aLob);
	json_utils.htp_output_clob(aLob, theJSONP);
	dbms_lob.freetemporary(aLob);
END htp;

END;
/
