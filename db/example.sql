# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.5.43-0ubuntu0.12.04.1)
# Database: cloudvm
# Generation Time: 2015-05-31 12:20:03 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table actions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `actions`;

CREATE TABLE `actions` (
  `aid` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Primary Key: Unique actions ID.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'The object that that action acts on (node, user, comment, system or custom types.)',
  `callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The callback function that executes when the action runs.',
  `parameters` longblob NOT NULL COMMENT 'Parameters to be passed to the callback function.',
  `label` varchar(255) NOT NULL DEFAULT '0' COMMENT 'Label of the action.',
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores action information.';

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;

INSERT INTO `actions` (`aid`, `type`, `callback`, `parameters`, `label`)
VALUES
	('comment_publish_action','comment','comment_publish_action','','Publish comment'),
	('comment_save_action','comment','comment_save_action','','Save comment'),
	('comment_unpublish_action','comment','comment_unpublish_action','','Unpublish comment'),
	('node_make_sticky_action','node','node_make_sticky_action','','Make content sticky'),
	('node_make_unsticky_action','node','node_make_unsticky_action','','Make content unsticky'),
	('node_promote_action','node','node_promote_action','','Promote content to front page'),
	('node_publish_action','node','node_publish_action','','Publish content'),
	('node_save_action','node','node_save_action','','Save content'),
	('node_unpromote_action','node','node_unpromote_action','','Remove content from front page'),
	('node_unpublish_action','node','node_unpublish_action','','Unpublish content'),
	('system_block_ip_action','user','system_block_ip_action','','Ban IP address of current user'),
	('user_block_user_action','user','user_block_user_action','','Block current user');

/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table authmap
# ------------------------------------------------------------

DROP TABLE IF EXISTS `authmap`;

CREATE TABLE `authmap` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique authmap ID.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'User’s users.uid.',
  `authname` varchar(128) NOT NULL DEFAULT '' COMMENT 'Unique authentication name.',
  `module` varchar(128) NOT NULL DEFAULT '' COMMENT 'Module which is controlling the authentication.',
  PRIMARY KEY (`aid`),
  UNIQUE KEY `authname` (`authname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores distributed authentication mapping.';



# Dump of table batch
# ------------------------------------------------------------

DROP TABLE IF EXISTS `batch`;

CREATE TABLE `batch` (
  `bid` int(10) unsigned NOT NULL COMMENT 'Primary Key: Unique batch ID.',
  `token` varchar(64) NOT NULL COMMENT 'A string token generated against the current user’s session id and the batch id, used to ensure that only the user who submitted the batch can effectively access it.',
  `timestamp` int(11) NOT NULL COMMENT 'A Unix timestamp indicating when this batch was submitted for processing. Stale batches are purged at cron time.',
  `batch` longblob COMMENT 'A serialized array containing the processing data for the batch.',
  PRIMARY KEY (`bid`),
  KEY `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores details about batches (processes that run in...';



# Dump of table block
# ------------------------------------------------------------

DROP TABLE IF EXISTS `block`;

CREATE TABLE `block` (
  `bid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique block ID.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The module from which the block originates; for example, ’user’ for the Who’s Online block, and ’block’ for any custom blocks.',
  `delta` varchar(32) NOT NULL DEFAULT '0' COMMENT 'Unique ID for block within a module.',
  `theme` varchar(64) NOT NULL DEFAULT '' COMMENT 'The theme under which the block settings apply.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Block enabled status. (1 = enabled, 0 = disabled)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Block weight within region.',
  `region` varchar(64) NOT NULL DEFAULT '' COMMENT 'Theme region within which the block is set.',
  `custom` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how users may control visibility of the block. (0 = Users cannot control, 1 = On by default, but can be hidden, 2 = Hidden by default, but can be shown)',
  `visibility` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate how to show blocks on pages. (0 = Show on all pages except listed pages, 1 = Show only on listed pages, 2 = Use custom PHP code to determine visibility)',
  `pages` text NOT NULL COMMENT 'Contents of the "Pages" block; contains either a list of paths on which to include/exclude the block or PHP code, depending on "visibility" setting.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'Custom title for the block. (Empty string will use block default title, <none> will remove the title, text will cause block to use specified title.)',
  `cache` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Binary flag to indicate block cache mode. (-2: Custom cache, -1: Do not cache, 1: Cache per role, 2: Cache per user, 4: Cache per page, 8: Block cache global) See DRUPAL_CACHE_* constants in ../includes/common.inc for more detailed information.',
  PRIMARY KEY (`bid`),
  UNIQUE KEY `tmd` (`theme`,`module`,`delta`),
  KEY `list` (`theme`,`status`,`region`,`weight`,`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores block settings, such as region and visibility...';

LOCK TABLES `block` WRITE;
/*!40000 ALTER TABLE `block` DISABLE KEYS */;

INSERT INTO `block` (`bid`, `module`, `delta`, `theme`, `status`, `weight`, `region`, `custom`, `visibility`, `pages`, `title`, `cache`)
VALUES
	(1,'system','main','bartik',1,0,'content',0,0,'','',-1),
	(2,'search','form','bartik',1,-1,'sidebar_first',0,0,'','',-1),
	(3,'node','recent','seven',1,10,'dashboard_main',0,0,'','',-1),
	(4,'user','login','bartik',1,0,'sidebar_first',0,0,'','',-1),
	(5,'system','navigation','bartik',1,0,'sidebar_first',0,0,'','',-1),
	(6,'system','powered-by','bartik',1,10,'footer',0,0,'','',-1),
	(7,'system','help','bartik',1,0,'help',0,0,'','',-1),
	(8,'system','main','seven',1,0,'content',0,0,'','',-1),
	(9,'system','help','seven',1,0,'help',0,0,'','',-1),
	(10,'user','login','seven',1,10,'content',0,0,'','',-1),
	(11,'user','new','seven',1,0,'dashboard_sidebar',0,0,'','',-1),
	(12,'search','form','seven',1,-10,'dashboard_sidebar',0,0,'','',-1),
	(13,'comment','recent','bartik',0,0,'-1',0,0,'','',1),
	(14,'node','syndicate','bartik',0,0,'-1',0,0,'','',-1),
	(15,'node','recent','bartik',0,0,'-1',0,0,'','',1),
	(16,'shortcut','shortcuts','bartik',0,0,'-1',0,0,'','',-1),
	(17,'system','management','bartik',0,0,'-1',0,0,'','',-1),
	(18,'system','user-menu','bartik',0,0,'-1',0,0,'','',-1),
	(19,'system','main-menu','bartik',0,0,'-1',0,0,'','',-1),
	(20,'user','new','bartik',0,0,'-1',0,0,'','',1),
	(21,'user','online','bartik',0,0,'-1',0,0,'','',-1),
	(22,'comment','recent','seven',1,0,'dashboard_inactive',0,0,'','',1),
	(23,'node','syndicate','seven',0,0,'-1',0,0,'','',-1),
	(24,'shortcut','shortcuts','seven',0,0,'-1',0,0,'','',-1),
	(25,'system','powered-by','seven',0,10,'-1',0,0,'','',-1),
	(26,'system','navigation','seven',0,0,'-1',0,0,'','',-1),
	(27,'system','management','seven',0,0,'-1',0,0,'','',-1),
	(28,'system','user-menu','seven',0,0,'-1',0,0,'','',-1),
	(29,'system','main-menu','seven',0,0,'-1',0,0,'','',-1),
	(30,'user','online','seven',1,0,'dashboard_inactive',0,0,'','',-1);

/*!40000 ALTER TABLE `block` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table block_custom
# ------------------------------------------------------------

DROP TABLE IF EXISTS `block_custom`;

CREATE TABLE `block_custom` (
  `bid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The block’s block.bid.',
  `body` longtext COMMENT 'Block contents.',
  `info` varchar(128) NOT NULL DEFAULT '' COMMENT 'Block description.',
  `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the block body.',
  PRIMARY KEY (`bid`),
  UNIQUE KEY `info` (`info`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores contents of custom-made blocks.';



# Dump of table block_node_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `block_node_type`;

CREATE TABLE `block_node_type` (
  `module` varchar(64) NOT NULL COMMENT 'The block’s origin module, from block.module.',
  `delta` varchar(32) NOT NULL COMMENT 'The block’s unique delta within module, from block.delta.',
  `type` varchar(32) NOT NULL COMMENT 'The machine-readable name of this type from node_type.type.',
  PRIMARY KEY (`module`,`delta`,`type`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Sets up display criteria for blocks based on content types';



# Dump of table block_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `block_role`;

CREATE TABLE `block_role` (
  `module` varchar(64) NOT NULL COMMENT 'The block’s origin module, from block.module.',
  `delta` varchar(32) NOT NULL COMMENT 'The block’s unique delta within module, from block.delta.',
  `rid` int(10) unsigned NOT NULL COMMENT 'The user’s role ID from users_roles.rid.',
  PRIMARY KEY (`module`,`delta`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Sets up access permissions for blocks based on user roles';



# Dump of table blocked_ips
# ------------------------------------------------------------

DROP TABLE IF EXISTS `blocked_ips`;

CREATE TABLE `blocked_ips` (
  `iid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: unique ID for IP addresses.',
  `ip` varchar(40) NOT NULL DEFAULT '' COMMENT 'IP address',
  PRIMARY KEY (`iid`),
  KEY `blocked_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores blocked IP addresses.';



# Dump of table cache
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Generic cache table for caching things not separated out...';



# Dump of table cache_block
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_block`;

CREATE TABLE `cache_block` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the Block module to store already built...';



# Dump of table cache_bootstrap
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_bootstrap`;

CREATE TABLE `cache_bootstrap` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for data required to bootstrap Drupal, may be...';



# Dump of table cache_field
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_field`;

CREATE TABLE `cache_field` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the Field module to store already built...';



# Dump of table cache_filter
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_filter`;

CREATE TABLE `cache_filter` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the Filter module to store already...';



# Dump of table cache_form
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_form`;

CREATE TABLE `cache_form` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the form system to store recently built...';



# Dump of table cache_image
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_image`;

CREATE TABLE `cache_image` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table used to store information about image...';



# Dump of table cache_menu
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_menu`;

CREATE TABLE `cache_menu` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for the menu system to store router...';



# Dump of table cache_page
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_page`;

CREATE TABLE `cache_page` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table used to store compressed pages for anonymous...';



# Dump of table cache_path
# ------------------------------------------------------------

DROP TABLE IF EXISTS `cache_path`;

CREATE TABLE `cache_path` (
  `cid` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique cache ID.',
  `data` longblob COMMENT 'A collection of data to cache.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry should expire, or 0 for never.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when the cache entry was created.',
  `serialized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate whether content is serialized (1) or not (0).',
  PRIMARY KEY (`cid`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Cache table for path alias lookup.';



# Dump of table comment
# ------------------------------------------------------------

DROP TABLE IF EXISTS `comment`;

CREATE TABLE `comment` (
  `cid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique comment ID.',
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT 'The comment.cid to which this comment is a reply. If set to 0, this comment is not a reply to an existing comment.',
  `nid` int(11) NOT NULL DEFAULT '0' COMMENT 'The node.nid to which this comment is a reply.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid who authored the comment. If set to 0, this comment was created by an anonymous user.',
  `subject` varchar(64) NOT NULL DEFAULT '' COMMENT 'The comment title.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'The author’s host name.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The time that the comment was created, as a Unix timestamp.',
  `changed` int(11) NOT NULL DEFAULT '0' COMMENT 'The time that the comment was last edited, as a Unix timestamp.',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'The published status of a comment. (0 = Not Published, 1 = Published)',
  `thread` varchar(255) NOT NULL COMMENT 'The vancode representation of the comment’s place in a thread.',
  `name` varchar(60) DEFAULT NULL COMMENT 'The comment author’s name. Uses users.name if the user is logged in, otherwise uses the value typed into the comment form.',
  `mail` varchar(64) DEFAULT NULL COMMENT 'The comment author’s e-mail address from the comment form, if user is anonymous, and the ’Anonymous users may/must leave their contact information’ setting is turned on.',
  `homepage` varchar(255) DEFAULT NULL COMMENT 'The comment author’s home page address from the comment form, if user is anonymous, and the ’Anonymous users may/must leave their contact information’ setting is turned on.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this comment.',
  PRIMARY KEY (`cid`),
  KEY `comment_status_pid` (`pid`,`status`),
  KEY `comment_num_new` (`nid`,`status`,`created`,`cid`,`thread`),
  KEY `comment_uid` (`uid`),
  KEY `comment_nid_language` (`nid`,`language`),
  KEY `comment_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores comments and associated data.';



# Dump of table date_format_locale
# ------------------------------------------------------------

DROP TABLE IF EXISTS `date_format_locale`;

CREATE TABLE `date_format_locale` (
  `format` varchar(100) NOT NULL COMMENT 'The date format string.',
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `language` varchar(12) NOT NULL COMMENT 'A languages.language for this format to be used with.',
  PRIMARY KEY (`type`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores configured date formats for each locale.';



# Dump of table date_format_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `date_format_type`;

CREATE TABLE `date_format_type` (
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `title` varchar(255) NOT NULL COMMENT 'The human readable name of the format type.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether or not this is a system provided format.',
  PRIMARY KEY (`type`),
  KEY `title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores configured date format types.';

LOCK TABLES `date_format_type` WRITE;
/*!40000 ALTER TABLE `date_format_type` DISABLE KEYS */;

INSERT INTO `date_format_type` (`type`, `title`, `locked`)
VALUES
	('long','Long',1),
	('medium','Medium',1),
	('short','Short',1);

/*!40000 ALTER TABLE `date_format_type` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table date_formats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `date_formats`;

CREATE TABLE `date_formats` (
  `dfid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The date format identifier.',
  `format` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'The date format string.',
  `type` varchar(64) NOT NULL COMMENT 'The date format type, e.g. medium.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether or not this format can be modified.',
  PRIMARY KEY (`dfid`),
  UNIQUE KEY `formats` (`format`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores configured date formats.';

LOCK TABLES `date_formats` WRITE;
/*!40000 ALTER TABLE `date_formats` DISABLE KEYS */;

INSERT INTO `date_formats` (`dfid`, `format`, `type`, `locked`)
VALUES
	(1,X'592D6D2D6420483A69','short',1),
	(2,X'6D2F642F59202D20483A69','short',1),
	(3,X'642F6D2F59202D20483A69','short',1),
	(4,X'592F6D2F64202D20483A69','short',1),
	(5,X'642E6D2E59202D20483A69','short',1),
	(6,X'6D2F642F59202D20673A6961','short',1),
	(7,X'642F6D2F59202D20673A6961','short',1),
	(8,X'592F6D2F64202D20673A6961','short',1),
	(9,X'4D206A2059202D20483A69','short',1),
	(10,X'6A204D2059202D20483A69','short',1),
	(11,X'59204D206A202D20483A69','short',1),
	(12,X'4D206A2059202D20673A6961','short',1),
	(13,X'6A204D2059202D20673A6961','short',1),
	(14,X'59204D206A202D20673A6961','short',1),
	(15,X'442C20592D6D2D6420483A69','medium',1),
	(16,X'442C206D2F642F59202D20483A69','medium',1),
	(17,X'442C20642F6D2F59202D20483A69','medium',1),
	(18,X'442C20592F6D2F64202D20483A69','medium',1),
	(19,X'46206A2C2059202D20483A69','medium',1),
	(20,X'6A20462C2059202D20483A69','medium',1),
	(21,X'592C2046206A202D20483A69','medium',1),
	(22,X'442C206D2F642F59202D20673A6961','medium',1),
	(23,X'442C20642F6D2F59202D20673A6961','medium',1),
	(24,X'442C20592F6D2F64202D20673A6961','medium',1),
	(25,X'46206A2C2059202D20673A6961','medium',1),
	(26,X'6A20462059202D20673A6961','medium',1),
	(27,X'592C2046206A202D20673A6961','medium',1),
	(28,X'6A2E20462059202D20473A69','medium',1),
	(29,X'6C2C2046206A2C2059202D20483A69','long',1),
	(30,X'6C2C206A20462C2059202D20483A69','long',1),
	(31,X'6C2C20592C202046206A202D20483A69','long',1),
	(32,X'6C2C2046206A2C2059202D20673A6961','long',1),
	(33,X'6C2C206A20462059202D20673A6961','long',1),
	(34,X'6C2C20592C202046206A202D20673A6961','long',1),
	(35,X'6C2C206A2E20462059202D20473A69','long',1);

/*!40000 ALTER TABLE `date_formats` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table field_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_config`;

CREATE TABLE `field_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a field',
  `field_name` varchar(32) NOT NULL COMMENT 'The name of this field. Non-deleted field names are unique, but multiple deleted fields can have the same name.',
  `type` varchar(128) NOT NULL COMMENT 'The type of this field.',
  `module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the field type.',
  `active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the field type is enabled.',
  `storage_type` varchar(128) NOT NULL COMMENT 'The storage backend for the field.',
  `storage_module` varchar(128) NOT NULL DEFAULT '' COMMENT 'The module that implements the storage backend.',
  `storage_active` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the module that implements the storage backend is enabled.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT '@TODO',
  `data` longblob NOT NULL COMMENT 'Serialized data containing the field properties that do not warrant a dedicated column.',
  `cardinality` tinyint(4) NOT NULL DEFAULT '0',
  `translatable` tinyint(4) NOT NULL DEFAULT '0',
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `field_name` (`field_name`),
  KEY `active` (`active`),
  KEY `storage_active` (`storage_active`),
  KEY `deleted` (`deleted`),
  KEY `module` (`module`),
  KEY `storage_module` (`storage_module`),
  KEY `type` (`type`),
  KEY `storage_type` (`storage_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `field_config` WRITE;
/*!40000 ALTER TABLE `field_config` DISABLE KEYS */;

INSERT INTO `field_config` (`id`, `field_name`, `type`, `module`, `active`, `storage_type`, `storage_module`, `storage_active`, `locked`, `data`, `cardinality`, `translatable`, `deleted`)
VALUES
	(1,'comment_body','text_long','text',1,'field_sql_storage','field_sql_storage',1,0,X'613A363A7B733A31323A22656E746974795F7479706573223B613A313A7B693A303B733A373A22636F6D6D656E74223B7D733A31323A227472616E736C617461626C65223B623A303B733A383A2273657474696E6773223B613A303A7B7D733A373A2273746F72616765223B613A343A7B733A343A2274797065223B733A31373A226669656C645F73716C5F73746F72616765223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A31373A226669656C645F73716C5F73746F72616765223B733A363A22616374697665223B693A313B7D733A31323A22666F726569676E206B657973223B613A313A7B733A363A22666F726D6174223B613A323A7B733A353A227461626C65223B733A31333A2266696C7465725F666F726D6174223B733A373A22636F6C756D6E73223B613A313A7B733A363A22666F726D6174223B733A363A22666F726D6174223B7D7D7D733A373A22696E6465786573223B613A313A7B733A363A22666F726D6174223B613A313A7B693A303B733A363A22666F726D6174223B7D7D7D',1,0,0),
	(2,'body','text_with_summary','text',1,'field_sql_storage','field_sql_storage',1,0,X'613A363A7B733A31323A22656E746974795F7479706573223B613A313A7B693A303B733A343A226E6F6465223B7D733A31323A227472616E736C617461626C65223B623A303B733A383A2273657474696E6773223B613A303A7B7D733A373A2273746F72616765223B613A343A7B733A343A2274797065223B733A31373A226669656C645F73716C5F73746F72616765223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A31373A226669656C645F73716C5F73746F72616765223B733A363A22616374697665223B693A313B7D733A31323A22666F726569676E206B657973223B613A313A7B733A363A22666F726D6174223B613A323A7B733A353A227461626C65223B733A31333A2266696C7465725F666F726D6174223B733A373A22636F6C756D6E73223B613A313A7B733A363A22666F726D6174223B733A363A22666F726D6174223B7D7D7D733A373A22696E6465786573223B613A313A7B733A363A22666F726D6174223B613A313A7B693A303B733A363A22666F726D6174223B7D7D7D',1,0,0),
	(3,'field_tags','taxonomy_term_reference','taxonomy',1,'field_sql_storage','field_sql_storage',1,0,X'613A363A7B733A383A2273657474696E6773223B613A313A7B733A31343A22616C6C6F7765645F76616C756573223B613A313A7B693A303B613A323A7B733A31303A22766F636162756C617279223B733A343A2274616773223B733A363A22706172656E74223B693A303B7D7D7D733A31323A22656E746974795F7479706573223B613A303A7B7D733A31323A227472616E736C617461626C65223B623A303B733A373A2273746F72616765223B613A343A7B733A343A2274797065223B733A31373A226669656C645F73716C5F73746F72616765223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A31373A226669656C645F73716C5F73746F72616765223B733A363A22616374697665223B693A313B7D733A31323A22666F726569676E206B657973223B613A313A7B733A333A22746964223B613A323A7B733A353A227461626C65223B733A31383A227461786F6E6F6D795F7465726D5F64617461223B733A373A22636F6C756D6E73223B613A313A7B733A333A22746964223B733A333A22746964223B7D7D7D733A373A22696E6465786573223B613A313A7B733A333A22746964223B613A313A7B693A303B733A333A22746964223B7D7D7D',-1,0,0),
	(4,'field_image','image','image',1,'field_sql_storage','field_sql_storage',1,0,X'613A363A7B733A373A22696E6465786573223B613A313A7B733A333A22666964223B613A313A7B693A303B733A333A22666964223B7D7D733A383A2273657474696E6773223B613A323A7B733A31303A227572695F736368656D65223B733A363A227075626C6963223B733A31333A2264656661756C745F696D616765223B623A303B7D733A373A2273746F72616765223B613A343A7B733A343A2274797065223B733A31373A226669656C645F73716C5F73746F72616765223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A31373A226669656C645F73716C5F73746F72616765223B733A363A22616374697665223B693A313B7D733A31323A22656E746974795F7479706573223B613A303A7B7D733A31323A227472616E736C617461626C65223B623A303B733A31323A22666F726569676E206B657973223B613A313A7B733A333A22666964223B613A323A7B733A353A227461626C65223B733A31323A2266696C655F6D616E61676564223B733A373A22636F6C756D6E73223B613A313A7B733A333A22666964223B733A333A22666964223B7D7D7D7D',1,0,0);

/*!40000 ALTER TABLE `field_config` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table field_config_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_config_instance`;

CREATE TABLE `field_config_instance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a field instance',
  `field_id` int(11) NOT NULL COMMENT 'The identifier of the field attached by this instance',
  `field_name` varchar(32) NOT NULL DEFAULT '',
  `entity_type` varchar(32) NOT NULL DEFAULT '',
  `bundle` varchar(128) NOT NULL DEFAULT '',
  `data` longblob NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `field_name_bundle` (`field_name`,`entity_type`,`bundle`),
  KEY `deleted` (`deleted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `field_config_instance` WRITE;
/*!40000 ALTER TABLE `field_config_instance` DISABLE KEYS */;

INSERT INTO `field_config_instance` (`id`, `field_id`, `field_name`, `entity_type`, `bundle`, `data`, `deleted`)
VALUES
	(1,1,'comment_body','comment','comment_node_page',X'613A363A7B733A353A226C6162656C223B733A373A22436F6D6D656E74223B733A383A2273657474696E6773223B613A323A7B733A31353A22746578745F70726F63657373696E67223B693A313B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A383A227265717569726564223B623A313B733A373A22646973706C6179223B613A313A7B733A373A2264656661756C74223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A31323A22746578745F64656661756C74223B733A363A22776569676874223B693A303B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A343A2274657874223B7D7D733A363A22776964676574223B613A343A7B733A343A2274797065223B733A31333A22746578745F7465787461726561223B733A383A2273657474696E6773223B613A313A7B733A343A22726F7773223B693A353B7D733A363A22776569676874223B693A303B733A363A226D6F64756C65223B733A343A2274657874223B7D733A31313A226465736372697074696F6E223B733A303A22223B7D',0),
	(2,2,'body','node','page',X'613A363A7B733A353A226C6162656C223B733A343A22426F6479223B733A363A22776964676574223B613A343A7B733A343A2274797065223B733A32363A22746578745F74657874617265615F776974685F73756D6D617279223B733A383A2273657474696E6773223B613A323A7B733A343A22726F7773223B693A32303B733A31323A2273756D6D6172795F726F7773223B693A353B7D733A363A22776569676874223B693A2D343B733A363A226D6F64756C65223B733A343A2274657874223B7D733A383A2273657474696E6773223B613A333A7B733A31353A22646973706C61795F73756D6D617279223B623A313B733A31353A22746578745F70726F63657373696E67223B693A313B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A373A22646973706C6179223B613A323A7B733A373A2264656661756C74223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A31323A22746578745F64656661756C74223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A343A2274657874223B733A363A22776569676874223B693A303B7D733A363A22746561736572223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A32333A22746578745F73756D6D6172795F6F725F7472696D6D6564223B733A383A2273657474696E6773223B613A313A7B733A31313A227472696D5F6C656E677468223B693A3630303B7D733A363A226D6F64756C65223B733A343A2274657874223B733A363A22776569676874223B693A303B7D7D733A383A227265717569726564223B623A303B733A31313A226465736372697074696F6E223B733A303A22223B7D',0),
	(3,1,'comment_body','comment','comment_node_article',X'613A363A7B733A353A226C6162656C223B733A373A22436F6D6D656E74223B733A383A2273657474696E6773223B613A323A7B733A31353A22746578745F70726F63657373696E67223B693A313B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A383A227265717569726564223B623A313B733A373A22646973706C6179223B613A313A7B733A373A2264656661756C74223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A31323A22746578745F64656661756C74223B733A363A22776569676874223B693A303B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A343A2274657874223B7D7D733A363A22776964676574223B613A343A7B733A343A2274797065223B733A31333A22746578745F7465787461726561223B733A383A2273657474696E6773223B613A313A7B733A343A22726F7773223B693A353B7D733A363A22776569676874223B693A303B733A363A226D6F64756C65223B733A343A2274657874223B7D733A31313A226465736372697074696F6E223B733A303A22223B7D',0),
	(4,2,'body','node','article',X'613A363A7B733A353A226C6162656C223B733A343A22426F6479223B733A363A22776964676574223B613A343A7B733A343A2274797065223B733A32363A22746578745F74657874617265615F776974685F73756D6D617279223B733A383A2273657474696E6773223B613A323A7B733A343A22726F7773223B693A32303B733A31323A2273756D6D6172795F726F7773223B693A353B7D733A363A22776569676874223B693A2D343B733A363A226D6F64756C65223B733A343A2274657874223B7D733A383A2273657474696E6773223B613A333A7B733A31353A22646973706C61795F73756D6D617279223B623A313B733A31353A22746578745F70726F63657373696E67223B693A313B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A373A22646973706C6179223B613A323A7B733A373A2264656661756C74223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A31323A22746578745F64656661756C74223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A343A2274657874223B733A363A22776569676874223B693A303B7D733A363A22746561736572223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A32333A22746578745F73756D6D6172795F6F725F7472696D6D6564223B733A383A2273657474696E6773223B613A313A7B733A31313A227472696D5F6C656E677468223B693A3630303B7D733A363A226D6F64756C65223B733A343A2274657874223B733A363A22776569676874223B693A303B7D7D733A383A227265717569726564223B623A303B733A31313A226465736372697074696F6E223B733A303A22223B7D',0),
	(5,3,'field_tags','node','article',X'613A363A7B733A353A226C6162656C223B733A343A2254616773223B733A31313A226465736372697074696F6E223B733A36333A22456E746572206120636F6D6D612D736570617261746564206C697374206F6620776F72647320746F20646573637269626520796F757220636F6E74656E742E223B733A363A22776964676574223B613A343A7B733A343A2274797065223B733A32313A227461786F6E6F6D795F6175746F636F6D706C657465223B733A363A22776569676874223B693A2D343B733A383A2273657474696E6773223B613A323A7B733A343A2273697A65223B693A36303B733A31373A226175746F636F6D706C6574655F70617468223B733A32313A227461786F6E6F6D792F6175746F636F6D706C657465223B7D733A363A226D6F64756C65223B733A383A227461786F6E6F6D79223B7D733A373A22646973706C6179223B613A323A7B733A373A2264656661756C74223B613A353A7B733A343A2274797065223B733A32383A227461786F6E6F6D795F7465726D5F7265666572656E63655F6C696E6B223B733A363A22776569676874223B693A31303B733A353A226C6162656C223B733A353A2261626F7665223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A383A227461786F6E6F6D79223B7D733A363A22746561736572223B613A353A7B733A343A2274797065223B733A32383A227461786F6E6F6D795F7465726D5F7265666572656E63655F6C696E6B223B733A363A22776569676874223B693A31303B733A353A226C6162656C223B733A353A2261626F7665223B733A383A2273657474696E6773223B613A303A7B7D733A363A226D6F64756C65223B733A383A227461786F6E6F6D79223B7D7D733A383A2273657474696E6773223B613A313A7B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A383A227265717569726564223B623A303B7D',0),
	(6,4,'field_image','node','article',X'613A363A7B733A353A226C6162656C223B733A353A22496D616765223B733A31313A226465736372697074696F6E223B733A34303A2255706C6F616420616E20696D61676520746F20676F207769746820746869732061727469636C652E223B733A383A227265717569726564223B623A303B733A383A2273657474696E6773223B613A393A7B733A31343A2266696C655F6469726563746F7279223B733A31313A226669656C642F696D616765223B733A31353A2266696C655F657874656E73696F6E73223B733A31363A22706E6720676966206A7067206A706567223B733A31323A226D61785F66696C6573697A65223B733A303A22223B733A31343A226D61785F7265736F6C7574696F6E223B733A303A22223B733A31343A226D696E5F7265736F6C7574696F6E223B733A303A22223B733A393A22616C745F6669656C64223B623A313B733A31313A227469746C655F6669656C64223B733A303A22223B733A31333A2264656661756C745F696D616765223B693A303B733A31383A22757365725F72656769737465725F666F726D223B623A303B7D733A363A22776964676574223B613A343A7B733A343A2274797065223B733A31313A22696D6167655F696D616765223B733A383A2273657474696E6773223B613A323A7B733A31383A2270726F67726573735F696E64696361746F72223B733A383A227468726F62626572223B733A31393A22707265766965775F696D6167655F7374796C65223B733A393A227468756D626E61696C223B7D733A363A22776569676874223B693A2D313B733A363A226D6F64756C65223B733A353A22696D616765223B7D733A373A22646973706C6179223B613A323A7B733A373A2264656661756C74223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A353A22696D616765223B733A383A2273657474696E6773223B613A323A7B733A31313A22696D6167655F7374796C65223B733A353A226C61726765223B733A31303A22696D6167655F6C696E6B223B733A303A22223B7D733A363A22776569676874223B693A2D313B733A363A226D6F64756C65223B733A353A22696D616765223B7D733A363A22746561736572223B613A353A7B733A353A226C6162656C223B733A363A2268696464656E223B733A343A2274797065223B733A353A22696D616765223B733A383A2273657474696E6773223B613A323A7B733A31313A22696D6167655F7374796C65223B733A363A226D656469756D223B733A31303A22696D6167655F6C696E6B223B733A373A22636F6E74656E74223B7D733A363A22776569676874223B693A2D313B733A363A226D6F64756C65223B733A353A22696D616765223B7D7D7D',0);

/*!40000 ALTER TABLE `field_config_instance` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table field_data_body
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_data_body`;

CREATE TABLE `field_data_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `body_value` longtext,
  `body_summary` longtext,
  `body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `body_format` (`body_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Data storage for field 2 (body)';



# Dump of table field_data_comment_body
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_data_comment_body`;

CREATE TABLE `field_data_comment_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `comment_body_value` longtext,
  `comment_body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `comment_body_format` (`comment_body_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Data storage for field 1 (comment_body)';



# Dump of table field_data_field_image
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_data_field_image`;

CREATE TABLE `field_data_field_image` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_image_fid` int(10) unsigned DEFAULT NULL COMMENT 'The file_managed.fid being referenced in this field.',
  `field_image_alt` varchar(512) DEFAULT NULL COMMENT 'Alternative image text, for the image’s ’alt’ attribute.',
  `field_image_title` varchar(1024) DEFAULT NULL COMMENT 'Image title text, for the image’s ’title’ attribute.',
  `field_image_width` int(10) unsigned DEFAULT NULL COMMENT 'The width of the image in pixels.',
  `field_image_height` int(10) unsigned DEFAULT NULL COMMENT 'The height of the image in pixels.',
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_image_fid` (`field_image_fid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Data storage for field 4 (field_image)';



# Dump of table field_data_field_tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_data_field_tags`;

CREATE TABLE `field_data_field_tags` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned DEFAULT NULL COMMENT 'The entity revision id this data is attached to, or NULL if the entity type is not versioned',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_tags_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_tags_tid` (`field_tags_tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Data storage for field 3 (field_tags)';



# Dump of table field_revision_body
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_revision_body`;

CREATE TABLE `field_revision_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `body_value` longtext,
  `body_summary` longtext,
  `body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `body_format` (`body_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 2 (body)';



# Dump of table field_revision_comment_body
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_revision_comment_body`;

CREATE TABLE `field_revision_comment_body` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `comment_body_value` longtext,
  `comment_body_format` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `comment_body_format` (`comment_body_format`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 1 (comment_body)';



# Dump of table field_revision_field_image
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_revision_field_image`;

CREATE TABLE `field_revision_field_image` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_image_fid` int(10) unsigned DEFAULT NULL COMMENT 'The file_managed.fid being referenced in this field.',
  `field_image_alt` varchar(512) DEFAULT NULL COMMENT 'Alternative image text, for the image’s ’alt’ attribute.',
  `field_image_title` varchar(1024) DEFAULT NULL COMMENT 'Image title text, for the image’s ’title’ attribute.',
  `field_image_width` int(10) unsigned DEFAULT NULL COMMENT 'The width of the image in pixels.',
  `field_image_height` int(10) unsigned DEFAULT NULL COMMENT 'The height of the image in pixels.',
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_image_fid` (`field_image_fid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 4 (field_image)';



# Dump of table field_revision_field_tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `field_revision_field_tags`;

CREATE TABLE `field_revision_field_tags` (
  `entity_type` varchar(128) NOT NULL DEFAULT '' COMMENT 'The entity type this data is attached to',
  `bundle` varchar(128) NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to',
  `language` varchar(32) NOT NULL DEFAULT '' COMMENT 'The language for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_tags_tid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entity_type`,`entity_id`,`revision_id`,`deleted`,`delta`,`language`),
  KEY `entity_type` (`entity_type`),
  KEY `bundle` (`bundle`),
  KEY `deleted` (`deleted`),
  KEY `entity_id` (`entity_id`),
  KEY `revision_id` (`revision_id`),
  KEY `language` (`language`),
  KEY `field_tags_tid` (`field_tags_tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Revision archive storage for field 3 (field_tags)';



# Dump of table file_managed
# ------------------------------------------------------------

DROP TABLE IF EXISTS `file_managed`;

CREATE TABLE `file_managed` (
  `fid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'File ID.',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The users.uid of the user who is associated with the file.',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the file with no path components. This may differ from the basename of the URI if the file is renamed to avoid overwriting an existing file.',
  `uri` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'The URI to access the file (either local or remote).',
  `filemime` varchar(255) NOT NULL DEFAULT '' COMMENT 'The file’s MIME type.',
  `filesize` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'The size of the file in bytes.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A field indicating the status of the file. Two status are defined in core: temporary (0) and permanent (1). Temporary files older than DRUPAL_MAXIMUM_TEMP_FILE_AGE will be removed during a cron run.',
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'UNIX timestamp for when the file was added.',
  PRIMARY KEY (`fid`),
  UNIQUE KEY `uri` (`uri`),
  KEY `uid` (`uid`),
  KEY `status` (`status`),
  KEY `timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores information for uploaded files.';



# Dump of table file_usage
# ------------------------------------------------------------

DROP TABLE IF EXISTS `file_usage`;

CREATE TABLE `file_usage` (
  `fid` int(10) unsigned NOT NULL COMMENT 'File ID.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the module that is using the file.',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT 'The name of the object type in which the file is used.',
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The primary key of the object using the file.',
  `count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The number of times this file is used by this object.',
  PRIMARY KEY (`fid`,`type`,`id`,`module`),
  KEY `type_id` (`type`,`id`),
  KEY `fid_count` (`fid`,`count`),
  KEY `fid_module` (`fid`,`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Track where a file is used.';



# Dump of table filter
# ------------------------------------------------------------

DROP TABLE IF EXISTS `filter`;

CREATE TABLE `filter` (
  `format` varchar(255) NOT NULL COMMENT 'Foreign key: The filter_format.format to which this filter is assigned.',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT 'The origin module of the filter.',
  `name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Name of the filter being referenced.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of filter within format.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Filter enabled status. (1 = enabled, 0 = disabled)',
  `settings` longblob COMMENT 'A serialized array of name value pairs that store the filter settings for the specific format.',
  PRIMARY KEY (`format`,`name`),
  KEY `list` (`weight`,`module`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table that maps filters (HTML corrector) to text formats ...';

LOCK TABLES `filter` WRITE;
/*!40000 ALTER TABLE `filter` DISABLE KEYS */;

INSERT INTO `filter` (`format`, `module`, `name`, `weight`, `status`, `settings`)
VALUES
	('filtered_html','filter','filter_autop',2,1,X'613A303A7B7D'),
	('filtered_html','filter','filter_html',1,1,X'613A333A7B733A31323A22616C6C6F7765645F68746D6C223B733A37343A223C613E203C656D3E203C7374726F6E673E203C636974653E203C626C6F636B71756F74653E203C636F64653E203C756C3E203C6F6C3E203C6C693E203C646C3E203C64743E203C64643E223B733A31363A2266696C7465725F68746D6C5F68656C70223B693A313B733A32303A2266696C7465725F68746D6C5F6E6F666F6C6C6F77223B693A303B7D'),
	('filtered_html','filter','filter_htmlcorrector',10,1,X'613A303A7B7D'),
	('filtered_html','filter','filter_html_escape',-10,0,X'613A303A7B7D'),
	('filtered_html','filter','filter_url',0,1,X'613A313A7B733A31373A2266696C7465725F75726C5F6C656E677468223B693A37323B7D'),
	('full_html','filter','filter_autop',1,1,X'613A303A7B7D'),
	('full_html','filter','filter_html',-10,0,X'613A333A7B733A31323A22616C6C6F7765645F68746D6C223B733A37343A223C613E203C656D3E203C7374726F6E673E203C636974653E203C626C6F636B71756F74653E203C636F64653E203C756C3E203C6F6C3E203C6C693E203C646C3E203C64743E203C64643E223B733A31363A2266696C7465725F68746D6C5F68656C70223B693A313B733A32303A2266696C7465725F68746D6C5F6E6F666F6C6C6F77223B693A303B7D'),
	('full_html','filter','filter_htmlcorrector',10,1,X'613A303A7B7D'),
	('full_html','filter','filter_html_escape',-10,0,X'613A303A7B7D'),
	('full_html','filter','filter_url',0,1,X'613A313A7B733A31373A2266696C7465725F75726C5F6C656E677468223B693A37323B7D'),
	('plain_text','filter','filter_autop',2,1,X'613A303A7B7D'),
	('plain_text','filter','filter_html',-10,0,X'613A333A7B733A31323A22616C6C6F7765645F68746D6C223B733A37343A223C613E203C656D3E203C7374726F6E673E203C636974653E203C626C6F636B71756F74653E203C636F64653E203C756C3E203C6F6C3E203C6C693E203C646C3E203C64743E203C64643E223B733A31363A2266696C7465725F68746D6C5F68656C70223B693A313B733A32303A2266696C7465725F68746D6C5F6E6F666F6C6C6F77223B693A303B7D'),
	('plain_text','filter','filter_htmlcorrector',10,0,X'613A303A7B7D'),
	('plain_text','filter','filter_html_escape',0,1,X'613A303A7B7D'),
	('plain_text','filter','filter_url',1,1,X'613A313A7B733A31373A2266696C7465725F75726C5F6C656E677468223B693A37323B7D');

/*!40000 ALTER TABLE `filter` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table filter_format
# ------------------------------------------------------------

DROP TABLE IF EXISTS `filter_format`;

CREATE TABLE `filter_format` (
  `format` varchar(255) NOT NULL COMMENT 'Primary Key: Unique machine name of the format.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the text format (Filtered HTML).',
  `cache` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Flag to indicate whether format is cacheable. (1 = cacheable, 0 = not cacheable)',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '1' COMMENT 'The status of the text format. (1 = enabled, 0 = disabled)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of text format to use when listing.',
  PRIMARY KEY (`format`),
  UNIQUE KEY `name` (`name`),
  KEY `status_weight` (`status`,`weight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores text formats: custom groupings of filters, such as...';

LOCK TABLES `filter_format` WRITE;
/*!40000 ALTER TABLE `filter_format` DISABLE KEYS */;

INSERT INTO `filter_format` (`format`, `name`, `cache`, `status`, `weight`)
VALUES
	('filtered_html','Filtered HTML',1,1,0),
	('full_html','Full HTML',1,1,1),
	('plain_text','Plain text',1,1,10);

/*!40000 ALTER TABLE `filter_format` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table flood
# ------------------------------------------------------------

DROP TABLE IF EXISTS `flood`;

CREATE TABLE `flood` (
  `fid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique flood event ID.',
  `event` varchar(64) NOT NULL DEFAULT '' COMMENT 'Name of event (e.g. contact).',
  `identifier` varchar(128) NOT NULL DEFAULT '' COMMENT 'Identifier of the visitor, such as an IP address or hostname.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp of the event.',
  `expiration` int(11) NOT NULL DEFAULT '0' COMMENT 'Expiration timestamp. Expired events are purged on cron run.',
  PRIMARY KEY (`fid`),
  KEY `allow` (`event`,`identifier`,`timestamp`),
  KEY `purge` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Flood controls the threshold of events, such as the...';



# Dump of table history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `history`;

CREATE TABLE `history` (
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that read the node nid.',
  `nid` int(11) NOT NULL DEFAULT '0' COMMENT 'The node.nid that was read.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp at which the read occurred.',
  PRIMARY KEY (`uid`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A record of which users have read which nodes.';



# Dump of table image_effects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `image_effects`;

CREATE TABLE `image_effects` (
  `ieid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for an image effect.',
  `isid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The image_styles.isid for an image style.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of the effect in the style.',
  `name` varchar(255) NOT NULL COMMENT 'The unique name of the effect to be executed.',
  `data` longblob NOT NULL COMMENT 'The configuration data for the effect.',
  PRIMARY KEY (`ieid`),
  KEY `isid` (`isid`),
  KEY `weight` (`weight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores configuration options for image effects.';



# Dump of table image_styles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `image_styles`;

CREATE TABLE `image_styles` (
  `isid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for an image style.',
  `name` varchar(255) NOT NULL COMMENT 'The style machine name.',
  `label` varchar(255) NOT NULL DEFAULT '' COMMENT 'The style administrative name.',
  PRIMARY KEY (`isid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores configuration options for image styles.';



# Dump of table menu_custom
# ------------------------------------------------------------

DROP TABLE IF EXISTS `menu_custom`;

CREATE TABLE `menu_custom` (
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique key for menu. This is used as a block delta so length is 32.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'Menu title; displayed at top of block.',
  `description` text COMMENT 'Menu description.',
  PRIMARY KEY (`menu_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Holds definitions for top-level custom menus (for example...';

LOCK TABLES `menu_custom` WRITE;
/*!40000 ALTER TABLE `menu_custom` DISABLE KEYS */;

INSERT INTO `menu_custom` (`menu_name`, `title`, `description`)
VALUES
	('main-menu','Main menu','The <em>Main</em> menu is used on many sites to show the major sections of the site, often in a top navigation bar.'),
	('management','Management','The <em>Management</em> menu contains links for administrative tasks.'),
	('navigation','Navigation','The <em>Navigation</em> menu contains links intended for site visitors. Links are added to the <em>Navigation</em> menu automatically by some modules.'),
	('user-menu','User menu','The <em>User</em> menu contains links related to the user\'s account, as well as the \'Log out\' link.');

/*!40000 ALTER TABLE `menu_custom` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table menu_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `menu_links`;

CREATE TABLE `menu_links` (
  `menu_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'The menu name. All links with the same menu name (such as ’navigation’) are part of the same menu.',
  `mlid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The menu link ID (mlid) is the integer primary key.',
  `plid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The parent link ID (plid) is the mlid of the link above in the hierarchy, or zero if the link is at the top level in its menu.',
  `link_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Drupal path or external path this link points to.',
  `router_path` varchar(255) NOT NULL DEFAULT '' COMMENT 'For links corresponding to a Drupal path (external = 0), this connects the link to a menu_router.path for joins.',
  `link_title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The text displayed for the link, which may be modified by a title callback stored in menu_router.',
  `options` blob COMMENT 'A serialized array of options to be passed to the url() or l() function, such as a query string or HTML attributes.',
  `module` varchar(255) NOT NULL DEFAULT 'system' COMMENT 'The name of the module that generated this link.',
  `hidden` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag for whether the link should be rendered in menus. (1 = a disabled menu item that may be shown on admin screens, -1 = a menu callback, 0 = a normal, visible link)',
  `external` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate if the link points to a full URL starting with a protocol, like http:// (1 = external, 0 = internal).',
  `has_children` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag indicating whether any links have this link as a parent (1 = children exist, 0 = no children).',
  `expanded` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag for whether this link should be rendered as expanded in menus - expanded links always have their child links displayed, instead of only when the link is in the active trail (1 = expanded, 0 = not expanded)',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Link weight among links in the same menu at the same depth.',
  `depth` smallint(6) NOT NULL DEFAULT '0' COMMENT 'The depth relative to the top level. A link with plid == 0 will have depth == 1.',
  `customized` smallint(6) NOT NULL DEFAULT '0' COMMENT 'A flag to indicate that the user has manually created or edited the link (1 = customized, 0 = not customized).',
  `p1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The first mlid in the materialized path. If N = depth, then pN must equal the mlid. If depth > 1 then p(N-1) must equal the plid. All pX where X > depth must equal zero. The columns p1 .. p9 are also called the parents.',
  `p2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The second mlid in the materialized path. See p1.',
  `p3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The third mlid in the materialized path. See p1.',
  `p4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The fourth mlid in the materialized path. See p1.',
  `p5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The fifth mlid in the materialized path. See p1.',
  `p6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The sixth mlid in the materialized path. See p1.',
  `p7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The seventh mlid in the materialized path. See p1.',
  `p8` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The eighth mlid in the materialized path. See p1.',
  `p9` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The ninth mlid in the materialized path. See p1.',
  `updated` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Flag that indicates that this link was generated during the update from Drupal 5.',
  PRIMARY KEY (`mlid`),
  KEY `path_menu` (`link_path`(128),`menu_name`),
  KEY `menu_plid_expand_child` (`menu_name`,`plid`,`expanded`,`has_children`),
  KEY `menu_parents` (`menu_name`,`p1`,`p2`,`p3`,`p4`,`p5`,`p6`,`p7`,`p8`,`p9`),
  KEY `router_path` (`router_path`(128))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains the individual links within a menu.';

LOCK TABLES `menu_links` WRITE;
/*!40000 ALTER TABLE `menu_links` DISABLE KEYS */;

INSERT INTO `menu_links` (`menu_name`, `mlid`, `plid`, `link_path`, `router_path`, `link_title`, `options`, `module`, `hidden`, `external`, `has_children`, `expanded`, `weight`, `depth`, `customized`, `p1`, `p2`, `p3`, `p4`, `p5`, `p6`, `p7`, `p8`, `p9`, `updated`)
VALUES
	('management',1,0,'admin','admin','Administration',X'613A303A7B7D','system',0,0,1,0,9,1,0,1,0,0,0,0,0,0,0,0,0),
	('user-menu',2,0,'user','user','User account',X'613A313A7B733A353A22616C746572223B623A313B7D','system',0,0,0,0,-10,1,0,2,0,0,0,0,0,0,0,0,0),
	('navigation',3,0,'comment/%','comment/%','Comment permalink',X'613A303A7B7D','system',0,0,1,0,0,1,0,3,0,0,0,0,0,0,0,0,0),
	('navigation',4,0,'filter/tips','filter/tips','Compose tips',X'613A303A7B7D','system',1,0,0,0,0,1,0,4,0,0,0,0,0,0,0,0,0),
	('navigation',5,0,'node/%','node/%','',X'613A303A7B7D','system',0,0,0,0,0,1,0,5,0,0,0,0,0,0,0,0,0),
	('navigation',6,0,'node/add','node/add','Add content',X'613A303A7B7D','system',0,0,1,0,0,1,0,6,0,0,0,0,0,0,0,0,0),
	('management',7,1,'admin/appearance','admin/appearance','Appearance',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33333A2253656C65637420616E6420636F6E66696775726520796F7572207468656D65732E223B7D7D','system',0,0,0,0,-6,2,0,1,7,0,0,0,0,0,0,0,0),
	('management',8,1,'admin/config','admin/config','Configuration',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32303A2241646D696E69737465722073657474696E67732E223B7D7D','system',0,0,1,0,0,2,0,1,8,0,0,0,0,0,0,0,0),
	('management',9,1,'admin/content','admin/content','Content',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33323A2241646D696E697374657220636F6E74656E7420616E6420636F6D6D656E74732E223B7D7D','system',0,0,1,0,-10,2,0,1,9,0,0,0,0,0,0,0,0),
	('user-menu',10,2,'user/register','user/register','Create new account',X'613A303A7B7D','system',-1,0,0,0,0,2,0,2,10,0,0,0,0,0,0,0,0),
	('management',11,1,'admin/dashboard','admin/dashboard','Dashboard',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33343A225669657720616E6420637573746F6D697A6520796F75722064617368626F6172642E223B7D7D','system',0,0,0,0,-15,2,0,1,11,0,0,0,0,0,0,0,0),
	('management',12,1,'admin/help','admin/help','Help',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34383A225265666572656E636520666F722075736167652C20636F6E66696775726174696F6E2C20616E64206D6F64756C65732E223B7D7D','system',0,0,0,0,9,2,0,1,12,0,0,0,0,0,0,0,0),
	('management',13,1,'admin/index','admin/index','Index',X'613A303A7B7D','system',-1,0,0,0,-18,2,0,1,13,0,0,0,0,0,0,0,0),
	('user-menu',14,2,'user/login','user/login','Log in',X'613A303A7B7D','system',-1,0,0,0,0,2,0,2,14,0,0,0,0,0,0,0,0),
	('user-menu',15,0,'user/logout','user/logout','Log out',X'613A303A7B7D','system',0,0,0,0,10,1,0,15,0,0,0,0,0,0,0,0,0),
	('management',16,1,'admin/modules','admin/modules','Modules',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32363A22457874656E6420736974652066756E6374696F6E616C6974792E223B7D7D','system',0,0,0,0,-2,2,0,1,16,0,0,0,0,0,0,0,0),
	('navigation',17,0,'user/%','user/%','My account',X'613A303A7B7D','system',0,0,1,0,0,1,0,17,0,0,0,0,0,0,0,0,0),
	('management',18,1,'admin/people','admin/people','People',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34353A224D616E6167652075736572206163636F756E74732C20726F6C65732C20616E64207065726D697373696F6E732E223B7D7D','system',0,0,0,0,-4,2,0,1,18,0,0,0,0,0,0,0,0),
	('management',19,1,'admin/reports','admin/reports','Reports',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33343A2256696577207265706F7274732C20757064617465732C20616E64206572726F72732E223B7D7D','system',0,0,1,0,5,2,0,1,19,0,0,0,0,0,0,0,0),
	('user-menu',20,2,'user/password','user/password','Request new password',X'613A303A7B7D','system',-1,0,0,0,0,2,0,2,20,0,0,0,0,0,0,0,0),
	('management',21,1,'admin/structure','admin/structure','Structure',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34353A2241646D696E697374657220626C6F636B732C20636F6E74656E742074797065732C206D656E75732C206574632E223B7D7D','system',0,0,1,0,-8,2,0,1,21,0,0,0,0,0,0,0,0),
	('management',22,1,'admin/tasks','admin/tasks','Tasks',X'613A303A7B7D','system',-1,0,0,0,-20,2,0,1,22,0,0,0,0,0,0,0,0),
	('navigation',23,0,'comment/reply/%','comment/reply/%','Add new comment',X'613A303A7B7D','system',0,0,0,0,0,1,0,23,0,0,0,0,0,0,0,0,0),
	('navigation',24,3,'comment/%/approve','comment/%/approve','Approve',X'613A303A7B7D','system',0,0,0,0,1,2,0,3,24,0,0,0,0,0,0,0,0),
	('navigation',25,3,'comment/%/delete','comment/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,2,2,0,3,25,0,0,0,0,0,0,0,0),
	('navigation',26,3,'comment/%/edit','comment/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,2,0,3,26,0,0,0,0,0,0,0,0),
	('navigation',27,0,'taxonomy/term/%','taxonomy/term/%','Taxonomy term',X'613A303A7B7D','system',0,0,0,0,0,1,0,27,0,0,0,0,0,0,0,0,0),
	('navigation',28,3,'comment/%/view','comment/%/view','View comment',X'613A303A7B7D','system',-1,0,0,0,-10,2,0,3,28,0,0,0,0,0,0,0,0),
	('management',29,18,'admin/people/create','admin/people/create','Add user',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,18,29,0,0,0,0,0,0,0),
	('management',30,21,'admin/structure/block','admin/structure/block','Blocks',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A37393A22436F6E666967757265207768617420626C6F636B20636F6E74656E74206170706561727320696E20796F75722073697465277320736964656261727320616E64206F7468657220726567696F6E732E223B7D7D','system',0,0,1,0,0,3,0,1,21,30,0,0,0,0,0,0,0),
	('navigation',31,17,'user/%/cancel','user/%/cancel','Cancel account',X'613A303A7B7D','system',0,0,1,0,0,2,0,17,31,0,0,0,0,0,0,0,0),
	('management',32,9,'admin/content/comment','admin/content/comment','Comments',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35393A224C69737420616E642065646974207369746520636F6D6D656E747320616E642074686520636F6D6D656E7420617070726F76616C2071756575652E223B7D7D','system',0,0,0,0,0,3,0,1,9,32,0,0,0,0,0,0,0),
	('management',33,11,'admin/dashboard/configure','admin/dashboard/configure','Configure available dashboard blocks',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35333A22436F6E66696775726520776869636820626C6F636B732063616E2062652073686F776E206F6E207468652064617368626F6172642E223B7D7D','system',-1,0,0,0,0,3,0,1,11,33,0,0,0,0,0,0,0),
	('management',34,9,'admin/content/node','admin/content/node','Content',X'613A303A7B7D','system',-1,0,0,0,-10,3,0,1,9,34,0,0,0,0,0,0,0),
	('management',35,8,'admin/config/content','admin/config/content','Content authoring',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35333A2253657474696E67732072656C6174656420746F20666F726D617474696E6720616E6420617574686F72696E6720636F6E74656E742E223B7D7D','system',0,0,1,0,-15,3,0,1,8,35,0,0,0,0,0,0,0),
	('management',36,21,'admin/structure/types','admin/structure/types','Content types',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A39323A224D616E61676520636F6E74656E742074797065732C20696E636C7564696E672064656661756C74207374617475732C2066726F6E7420706167652070726F6D6F74696F6E2C20636F6D6D656E742073657474696E67732C206574632E223B7D7D','system',0,0,1,0,0,3,0,1,21,36,0,0,0,0,0,0,0),
	('management',37,11,'admin/dashboard/customize','admin/dashboard/customize','Customize dashboard',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32353A22437573746F6D697A6520796F75722064617368626F6172642E223B7D7D','system',-1,0,0,0,0,3,0,1,11,37,0,0,0,0,0,0,0),
	('navigation',38,5,'node/%/delete','node/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,1,2,0,5,38,0,0,0,0,0,0,0,0),
	('management',39,8,'admin/config/development','admin/config/development','Development',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A31383A22446576656C6F706D656E7420746F6F6C732E223B7D7D','system',0,0,1,0,-10,3,0,1,8,39,0,0,0,0,0,0,0),
	('navigation',40,17,'user/%/edit','user/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,2,0,17,40,0,0,0,0,0,0,0,0),
	('navigation',41,5,'node/%/edit','node/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,2,0,5,41,0,0,0,0,0,0,0,0),
	('management',42,19,'admin/reports/fields','admin/reports/fields','Field list',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33393A224F76657276696577206F66206669656C6473206F6E20616C6C20656E746974792074797065732E223B7D7D','system',0,0,0,0,0,3,0,1,19,42,0,0,0,0,0,0,0),
	('management',43,7,'admin/appearance/list','admin/appearance/list','List',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33313A2253656C65637420616E6420636F6E66696775726520796F7572207468656D65223B7D7D','system',-1,0,0,0,-1,3,0,1,7,43,0,0,0,0,0,0,0),
	('management',44,16,'admin/modules/list','admin/modules/list','List',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,16,44,0,0,0,0,0,0,0),
	('management',45,18,'admin/people/people','admin/people/people','List',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35303A2246696E6420616E64206D616E6167652070656F706C6520696E746572616374696E67207769746820796F757220736974652E223B7D7D','system',-1,0,0,0,-10,3,0,1,18,45,0,0,0,0,0,0,0),
	('management',46,8,'admin/config/media','admin/config/media','Media',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A31323A224D6564696120746F6F6C732E223B7D7D','system',0,0,1,0,-10,3,0,1,8,46,0,0,0,0,0,0,0),
	('management',47,21,'admin/structure/menu','admin/structure/menu','Menus',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A38363A22416464206E6577206D656E757320746F20796F757220736974652C2065646974206578697374696E67206D656E75732C20616E642072656E616D6520616E642072656F7267616E697A65206D656E75206C696E6B732E223B7D7D','system',0,0,1,0,0,3,0,1,21,47,0,0,0,0,0,0,0),
	('management',48,8,'admin/config/people','admin/config/people','People',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32343A22436F6E6669677572652075736572206163636F756E74732E223B7D7D','system',0,0,1,0,-20,3,0,1,8,48,0,0,0,0,0,0,0),
	('management',49,18,'admin/people/permissions','admin/people/permissions','Permissions',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36343A2244657465726D696E652061636365737320746F2066656174757265732062792073656C656374696E67207065726D697373696F6E7320666F7220726F6C65732E223B7D7D','system',-1,0,0,0,0,3,0,1,18,49,0,0,0,0,0,0,0),
	('management',50,19,'admin/reports/dblog','admin/reports/dblog','Recent log messages',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34333A2256696577206576656E74732074686174206861766520726563656E746C79206265656E206C6F676765642E223B7D7D','system',0,0,0,0,-1,3,0,1,19,50,0,0,0,0,0,0,0),
	('management',51,8,'admin/config/regional','admin/config/regional','Regional and language',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34383A22526567696F6E616C2073657474696E67732C206C6F63616C697A6174696F6E20616E64207472616E736C6174696F6E2E223B7D7D','system',0,0,1,0,-5,3,0,1,8,51,0,0,0,0,0,0,0),
	('navigation',52,5,'node/%/revisions','node/%/revisions','Revisions',X'613A303A7B7D','system',-1,0,1,0,2,2,0,5,52,0,0,0,0,0,0,0,0),
	('management',53,8,'admin/config/search','admin/config/search','Search and metadata',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33363A224C6F63616C2073697465207365617263682C206D6574616461746120616E642053454F2E223B7D7D','system',0,0,1,0,-10,3,0,1,8,53,0,0,0,0,0,0,0),
	('management',54,7,'admin/appearance/settings','admin/appearance/settings','Settings',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34363A22436F6E6669677572652064656661756C7420616E64207468656D652073706563696669632073657474696E67732E223B7D7D','system',-1,0,0,0,20,3,0,1,7,54,0,0,0,0,0,0,0),
	('management',55,19,'admin/reports/status','admin/reports/status','Status report',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A37343A22476574206120737461747573207265706F72742061626F757420796F757220736974652773206F7065726174696F6E20616E6420616E792064657465637465642070726F626C656D732E223B7D7D','system',0,0,0,0,-60,3,0,1,19,55,0,0,0,0,0,0,0),
	('management',56,8,'admin/config/system','admin/config/system','System',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33373A2247656E6572616C2073797374656D2072656C6174656420636F6E66696775726174696F6E2E223B7D7D','system',0,0,1,0,-20,3,0,1,8,56,0,0,0,0,0,0,0),
	('management',57,21,'admin/structure/taxonomy','admin/structure/taxonomy','Taxonomy',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36373A224D616E6167652074616767696E672C2063617465676F72697A6174696F6E2C20616E6420636C617373696669636174696F6E206F6620796F757220636F6E74656E742E223B7D7D','system',0,0,1,0,0,3,0,1,21,57,0,0,0,0,0,0,0),
	('management',58,19,'admin/reports/access-denied','admin/reports/access-denied','Top \'access denied\' errors',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33353A225669657720276163636573732064656E69656427206572726F7273202834303373292E223B7D7D','system',0,0,0,0,0,3,0,1,19,58,0,0,0,0,0,0,0),
	('management',59,19,'admin/reports/page-not-found','admin/reports/page-not-found','Top \'page not found\' errors',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33363A2256696577202770616765206E6F7420666F756E6427206572726F7273202834303473292E223B7D7D','system',0,0,0,0,0,3,0,1,19,59,0,0,0,0,0,0,0),
	('management',60,16,'admin/modules/uninstall','admin/modules/uninstall','Uninstall',X'613A303A7B7D','system',-1,0,0,0,20,3,0,1,16,60,0,0,0,0,0,0,0),
	('management',61,8,'admin/config/user-interface','admin/config/user-interface','User interface',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33383A22546F6F6C73207468617420656E68616E636520746865207573657220696E746572666163652E223B7D7D','system',0,0,1,0,-15,3,0,1,8,61,0,0,0,0,0,0,0),
	('navigation',62,5,'node/%/view','node/%/view','View',X'613A303A7B7D','system',-1,0,0,0,-10,2,0,5,62,0,0,0,0,0,0,0,0),
	('navigation',63,17,'user/%/view','user/%/view','View',X'613A303A7B7D','system',-1,0,0,0,-10,2,0,17,63,0,0,0,0,0,0,0,0),
	('management',64,8,'admin/config/services','admin/config/services','Web services',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33303A22546F6F6C732072656C6174656420746F207765622073657276696365732E223B7D7D','system',0,0,1,0,0,3,0,1,8,64,0,0,0,0,0,0,0),
	('management',65,8,'admin/config/workflow','admin/config/workflow','Workflow',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34333A22436F6E74656E7420776F726B666C6F772C20656469746F7269616C20776F726B666C6F7720746F6F6C732E223B7D7D','system',0,0,0,0,5,3,0,1,8,65,0,0,0,0,0,0,0),
	('management',66,12,'admin/help/block','admin/help/block','block',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,66,0,0,0,0,0,0,0),
	('management',67,12,'admin/help/color','admin/help/color','color',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,67,0,0,0,0,0,0,0),
	('management',68,12,'admin/help/comment','admin/help/comment','comment',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,68,0,0,0,0,0,0,0),
	('management',69,12,'admin/help/contextual','admin/help/contextual','contextual',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,69,0,0,0,0,0,0,0),
	('management',70,12,'admin/help/dashboard','admin/help/dashboard','dashboard',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,70,0,0,0,0,0,0,0),
	('management',71,12,'admin/help/dblog','admin/help/dblog','dblog',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,71,0,0,0,0,0,0,0),
	('management',72,12,'admin/help/field','admin/help/field','field',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,72,0,0,0,0,0,0,0),
	('management',73,12,'admin/help/field_sql_storage','admin/help/field_sql_storage','field_sql_storage',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,73,0,0,0,0,0,0,0),
	('management',74,12,'admin/help/field_ui','admin/help/field_ui','field_ui',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,74,0,0,0,0,0,0,0),
	('management',75,12,'admin/help/file','admin/help/file','file',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,75,0,0,0,0,0,0,0),
	('management',76,12,'admin/help/filter','admin/help/filter','filter',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,76,0,0,0,0,0,0,0),
	('management',77,12,'admin/help/help','admin/help/help','help',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,77,0,0,0,0,0,0,0),
	('management',78,12,'admin/help/image','admin/help/image','image',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,78,0,0,0,0,0,0,0),
	('management',79,12,'admin/help/list','admin/help/list','list',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,79,0,0,0,0,0,0,0),
	('management',80,12,'admin/help/menu','admin/help/menu','menu',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,80,0,0,0,0,0,0,0),
	('management',81,12,'admin/help/node','admin/help/node','node',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,81,0,0,0,0,0,0,0),
	('management',82,12,'admin/help/options','admin/help/options','options',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,82,0,0,0,0,0,0,0),
	('management',83,12,'admin/help/system','admin/help/system','system',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,83,0,0,0,0,0,0,0),
	('management',84,12,'admin/help/taxonomy','admin/help/taxonomy','taxonomy',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,84,0,0,0,0,0,0,0),
	('management',85,12,'admin/help/text','admin/help/text','text',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,85,0,0,0,0,0,0,0),
	('management',86,12,'admin/help/user','admin/help/user','user',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,86,0,0,0,0,0,0,0),
	('navigation',87,27,'taxonomy/term/%/edit','taxonomy/term/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,10,2,0,27,87,0,0,0,0,0,0,0,0),
	('navigation',88,27,'taxonomy/term/%/view','taxonomy/term/%/view','View',X'613A303A7B7D','system',-1,0,0,0,0,2,0,27,88,0,0,0,0,0,0,0,0),
	('management',89,57,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','',X'613A303A7B7D','system',0,0,0,0,0,4,0,1,21,57,89,0,0,0,0,0,0),
	('management',90,48,'admin/config/people/accounts','admin/config/people/accounts','Account settings',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3130393A22436F6E6669677572652064656661756C74206265686176696F72206F662075736572732C20696E636C7564696E6720726567697374726174696F6E20726571756972656D656E74732C20652D6D61696C732C206669656C64732C20616E6420757365722070696374757265732E223B7D7D','system',0,0,0,0,-10,4,0,1,8,48,90,0,0,0,0,0,0),
	('management',91,56,'admin/config/system/actions','admin/config/system/actions','Actions',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34313A224D616E6167652074686520616374696F6E7320646566696E656420666F7220796F757220736974652E223B7D7D','system',0,0,1,0,0,4,0,1,8,56,91,0,0,0,0,0,0),
	('management',92,30,'admin/structure/block/add','admin/structure/block/add','Add block',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,30,92,0,0,0,0,0,0),
	('management',93,36,'admin/structure/types/add','admin/structure/types/add','Add content type',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,36,93,0,0,0,0,0,0),
	('management',94,47,'admin/structure/menu/add','admin/structure/menu/add','Add menu',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,47,94,0,0,0,0,0,0),
	('management',95,57,'admin/structure/taxonomy/add','admin/structure/taxonomy/add','Add vocabulary',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,57,95,0,0,0,0,0,0),
	('management',96,54,'admin/appearance/settings/bartik','admin/appearance/settings/bartik','Bartik',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,7,54,96,0,0,0,0,0,0),
	('management',97,53,'admin/config/search/clean-urls','admin/config/search/clean-urls','Clean URLs',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34333A22456E61626C65206F722064697361626C6520636C65616E2055524C7320666F7220796F757220736974652E223B7D7D','system',0,0,0,0,5,4,0,1,8,53,97,0,0,0,0,0,0),
	('management',98,56,'admin/config/system/cron','admin/config/system/cron','Cron',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34303A224D616E616765206175746F6D617469632073697465206D61696E74656E616E6365207461736B732E223B7D7D','system',0,0,0,0,20,4,0,1,8,56,98,0,0,0,0,0,0),
	('management',99,51,'admin/config/regional/date-time','admin/config/regional/date-time','Date and time',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34343A22436F6E66696775726520646973706C617920666F726D61747320666F72206461746520616E642074696D652E223B7D7D','system',0,0,0,0,-15,4,0,1,8,51,99,0,0,0,0,0,0),
	('management',100,19,'admin/reports/event/%','admin/reports/event/%','Details',X'613A303A7B7D','system',0,0,0,0,0,3,0,1,19,100,0,0,0,0,0,0,0),
	('management',101,46,'admin/config/media/file-system','admin/config/media/file-system','File system',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36383A2254656C6C2044727570616C20776865726520746F2073746F72652075706C6F616465642066696C657320616E6420686F772074686579206172652061636365737365642E223B7D7D','system',0,0,0,0,-10,4,0,1,8,46,101,0,0,0,0,0,0),
	('management',102,54,'admin/appearance/settings/garland','admin/appearance/settings/garland','Garland',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,7,54,102,0,0,0,0,0,0),
	('management',103,54,'admin/appearance/settings/global','admin/appearance/settings/global','Global settings',X'613A303A7B7D','system',-1,0,0,0,-1,4,0,1,7,54,103,0,0,0,0,0,0),
	('management',104,48,'admin/config/people/ip-blocking','admin/config/people/ip-blocking','IP address blocking',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32383A224D616E61676520626C6F636B6564204950206164647265737365732E223B7D7D','system',0,0,1,0,10,4,0,1,8,48,104,0,0,0,0,0,0),
	('management',105,46,'admin/config/media/image-styles','admin/config/media/image-styles','Image styles',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A37383A22436F6E666967757265207374796C657320746861742063616E206265207573656420666F7220726573697A696E67206F722061646A757374696E6720696D61676573206F6E20646973706C61792E223B7D7D','system',0,0,1,0,0,4,0,1,8,46,105,0,0,0,0,0,0),
	('management',106,46,'admin/config/media/image-toolkit','admin/config/media/image-toolkit','Image toolkit',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A37343A2243686F6F736520776869636820696D61676520746F6F6C6B697420746F2075736520696620796F75206861766520696E7374616C6C6564206F7074696F6E616C20746F6F6C6B6974732E223B7D7D','system',0,0,0,0,20,4,0,1,8,46,106,0,0,0,0,0,0),
	('management',107,44,'admin/modules/list/confirm','admin/modules/list/confirm','List',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,16,44,107,0,0,0,0,0,0),
	('management',108,36,'admin/structure/types/list','admin/structure/types/list','List',X'613A303A7B7D','system',-1,0,0,0,-10,4,0,1,21,36,108,0,0,0,0,0,0),
	('management',109,57,'admin/structure/taxonomy/list','admin/structure/taxonomy/list','List',X'613A303A7B7D','system',-1,0,0,0,-10,4,0,1,21,57,109,0,0,0,0,0,0),
	('management',110,47,'admin/structure/menu/list','admin/structure/menu/list','List menus',X'613A303A7B7D','system',-1,0,0,0,-10,4,0,1,21,47,110,0,0,0,0,0,0),
	('management',111,39,'admin/config/development/logging','admin/config/development/logging','Logging and errors',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3135343A2253657474696E677320666F72206C6F6767696E6720616E6420616C65727473206D6F64756C65732E20566172696F7573206D6F64756C65732063616E20726F7574652044727570616C27732073797374656D206576656E747320746F20646966666572656E742064657374696E6174696F6E732C2073756368206173207379736C6F672C2064617461626173652C20656D61696C2C206574632E223B7D7D','system',0,0,0,0,-15,4,0,1,8,39,111,0,0,0,0,0,0),
	('management',112,39,'admin/config/development/maintenance','admin/config/development/maintenance','Maintenance mode',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36323A2254616B65207468652073697465206F66666C696E6520666F72206D61696E74656E616E6365206F72206272696E67206974206261636B206F6E6C696E652E223B7D7D','system',0,0,0,0,-10,4,0,1,8,39,112,0,0,0,0,0,0),
	('management',113,39,'admin/config/development/performance','admin/config/development/performance','Performance',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3130313A22456E61626C65206F722064697361626C6520706167652063616368696E6720666F7220616E6F6E796D6F757320757365727320616E64207365742043535320616E64204A532062616E647769647468206F7074696D697A6174696F6E206F7074696F6E732E223B7D7D','system',0,0,0,0,-20,4,0,1,8,39,113,0,0,0,0,0,0),
	('management',114,49,'admin/people/permissions/list','admin/people/permissions/list','Permissions',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36343A2244657465726D696E652061636365737320746F2066656174757265732062792073656C656374696E67207065726D697373696F6E7320666F7220726F6C65732E223B7D7D','system',-1,0,0,0,-8,4,0,1,18,49,114,0,0,0,0,0,0),
	('management',115,32,'admin/content/comment/new','admin/content/comment/new','Published comments',X'613A303A7B7D','system',-1,0,0,0,-10,4,0,1,9,32,115,0,0,0,0,0,0),
	('management',116,64,'admin/config/services/rss-publishing','admin/config/services/rss-publishing','RSS publishing',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3131343A22436F6E666967757265207468652073697465206465736372697074696F6E2C20746865206E756D626572206F66206974656D7320706572206665656420616E6420776865746865722066656564732073686F756C64206265207469746C65732F746561736572732F66756C6C2D746578742E223B7D7D','system',0,0,0,0,0,4,0,1,8,64,116,0,0,0,0,0,0),
	('management',117,51,'admin/config/regional/settings','admin/config/regional/settings','Regional settings',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35343A2253657474696E677320666F7220746865207369746527732064656661756C742074696D65207A6F6E6520616E6420636F756E7472792E223B7D7D','system',0,0,0,0,-20,4,0,1,8,51,117,0,0,0,0,0,0),
	('management',118,49,'admin/people/permissions/roles','admin/people/permissions/roles','Roles',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33303A224C6973742C20656469742C206F7220616464207573657220726F6C65732E223B7D7D','system',-1,0,1,0,-5,4,0,1,18,49,118,0,0,0,0,0,0),
	('management',119,47,'admin/structure/menu/settings','admin/structure/menu/settings','Settings',X'613A303A7B7D','system',-1,0,0,0,5,4,0,1,21,47,119,0,0,0,0,0,0),
	('management',120,54,'admin/appearance/settings/seven','admin/appearance/settings/seven','Seven',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,7,54,120,0,0,0,0,0,0),
	('management',121,56,'admin/config/system/site-information','admin/config/system/site-information','Site information',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3130343A224368616E67652073697465206E616D652C20652D6D61696C20616464726573732C20736C6F67616E2C2064656661756C742066726F6E7420706167652C20616E64206E756D626572206F6620706F7374732070657220706167652C206572726F722070616765732E223B7D7D','system',0,0,0,0,-20,4,0,1,8,56,121,0,0,0,0,0,0),
	('management',122,54,'admin/appearance/settings/stark','admin/appearance/settings/stark','Stark',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,7,54,122,0,0,0,0,0,0),
	('management',123,35,'admin/config/content/formats','admin/config/content/formats','Text formats',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A3132373A22436F6E66696775726520686F7720636F6E74656E7420696E7075742062792075736572732069732066696C74657265642C20696E636C7564696E6720616C6C6F7765642048544D4C20746167732E20416C736F20616C6C6F777320656E61626C696E67206F66206D6F64756C652D70726F76696465642066696C746572732E223B7D7D','system',0,0,1,0,0,4,0,1,8,35,123,0,0,0,0,0,0),
	('management',124,32,'admin/content/comment/approval','admin/content/comment/approval','Unapproved comments',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,9,32,124,0,0,0,0,0,0),
	('management',125,60,'admin/modules/uninstall/confirm','admin/modules/uninstall/confirm','Uninstall',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,16,60,125,0,0,0,0,0,0),
	('navigation',126,40,'user/%/edit/account','user/%/edit/account','Account',X'613A303A7B7D','system',-1,0,0,0,0,3,0,17,40,126,0,0,0,0,0,0,0),
	('management',127,123,'admin/config/content/formats/%','admin/config/content/formats/%','',X'613A303A7B7D','system',0,0,1,0,0,5,0,1,8,35,123,127,0,0,0,0,0),
	('management',128,105,'admin/config/media/image-styles/add','admin/config/media/image-styles/add','Add style',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32323A224164642061206E657720696D616765207374796C652E223B7D7D','system',-1,0,0,0,2,5,0,1,8,46,105,128,0,0,0,0,0),
	('management',129,89,'admin/structure/taxonomy/%/add','admin/structure/taxonomy/%/add','Add term',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,57,89,129,0,0,0,0,0),
	('management',130,123,'admin/config/content/formats/add','admin/config/content/formats/add','Add text format',X'613A303A7B7D','system',-1,0,0,0,1,5,0,1,8,35,123,130,0,0,0,0,0),
	('management',131,30,'admin/structure/block/list/bartik','admin/structure/block/list/bartik','Bartik',X'613A303A7B7D','system',-1,0,0,0,-10,4,0,1,21,30,131,0,0,0,0,0,0),
	('management',132,91,'admin/config/system/actions/configure','admin/config/system/actions/configure','Configure an advanced action',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,8,56,91,132,0,0,0,0,0),
	('management',133,47,'admin/structure/menu/manage/%','admin/structure/menu/manage/%','Customize menu',X'613A303A7B7D','system',0,0,1,0,0,4,0,1,21,47,133,0,0,0,0,0,0),
	('management',134,89,'admin/structure/taxonomy/%/edit','admin/structure/taxonomy/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,-10,5,0,1,21,57,89,134,0,0,0,0,0),
	('management',135,36,'admin/structure/types/manage/%','admin/structure/types/manage/%','Edit content type',X'613A303A7B7D','system',0,0,1,0,0,4,0,1,21,36,135,0,0,0,0,0,0),
	('management',136,99,'admin/config/regional/date-time/formats','admin/config/regional/date-time/formats','Formats',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A35313A22436F6E66696775726520646973706C617920666F726D617420737472696E677320666F72206461746520616E642074696D652E223B7D7D','system',-1,0,1,0,-9,5,0,1,8,51,99,136,0,0,0,0,0),
	('management',137,30,'admin/structure/block/list/garland','admin/structure/block/list/garland','Garland',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,30,137,0,0,0,0,0,0),
	('management',138,123,'admin/config/content/formats/list','admin/config/content/formats/list','List',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,8,35,123,138,0,0,0,0,0),
	('management',139,89,'admin/structure/taxonomy/%/list','admin/structure/taxonomy/%/list','List',X'613A303A7B7D','system',-1,0,0,0,-20,5,0,1,21,57,89,139,0,0,0,0,0),
	('management',140,105,'admin/config/media/image-styles/list','admin/config/media/image-styles/list','List',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34323A224C697374207468652063757272656E7420696D616765207374796C6573206F6E2074686520736974652E223B7D7D','system',-1,0,0,0,1,5,0,1,8,46,105,140,0,0,0,0,0),
	('management',141,91,'admin/config/system/actions/manage','admin/config/system/actions/manage','Manage actions',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34313A224D616E6167652074686520616374696F6E7320646566696E656420666F7220796F757220736974652E223B7D7D','system',-1,0,0,0,-2,5,0,1,8,56,91,141,0,0,0,0,0),
	('management',142,90,'admin/config/people/accounts/settings','admin/config/people/accounts/settings','Settings',X'613A303A7B7D','system',-1,0,0,0,-10,5,0,1,8,48,90,142,0,0,0,0,0),
	('management',143,30,'admin/structure/block/list/seven','admin/structure/block/list/seven','Seven',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,30,143,0,0,0,0,0,0),
	('management',144,30,'admin/structure/block/list/stark','admin/structure/block/list/stark','Stark',X'613A303A7B7D','system',-1,0,0,0,0,4,0,1,21,30,144,0,0,0,0,0,0),
	('management',145,99,'admin/config/regional/date-time/types','admin/config/regional/date-time/types','Types',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34343A22436F6E66696775726520646973706C617920666F726D61747320666F72206461746520616E642074696D652E223B7D7D','system',-1,0,1,0,-10,5,0,1,8,51,99,145,0,0,0,0,0),
	('navigation',146,52,'node/%/revisions/%/delete','node/%/revisions/%/delete','Delete earlier revision',X'613A303A7B7D','system',0,0,0,0,0,3,0,5,52,146,0,0,0,0,0,0,0),
	('navigation',147,52,'node/%/revisions/%/revert','node/%/revisions/%/revert','Revert to earlier revision',X'613A303A7B7D','system',0,0,0,0,0,3,0,5,52,147,0,0,0,0,0,0,0),
	('navigation',148,52,'node/%/revisions/%/view','node/%/revisions/%/view','Revisions',X'613A303A7B7D','system',0,0,0,0,0,3,0,5,52,148,0,0,0,0,0,0,0),
	('management',149,137,'admin/structure/block/list/garland/add','admin/structure/block/list/garland/add','Add block',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,30,137,149,0,0,0,0,0),
	('management',150,143,'admin/structure/block/list/seven/add','admin/structure/block/list/seven/add','Add block',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,30,143,150,0,0,0,0,0),
	('management',151,144,'admin/structure/block/list/stark/add','admin/structure/block/list/stark/add','Add block',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,30,144,151,0,0,0,0,0),
	('management',152,145,'admin/config/regional/date-time/types/add','admin/config/regional/date-time/types/add','Add date type',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A31383A22416464206E6577206461746520747970652E223B7D7D','system',-1,0,0,0,-10,6,0,1,8,51,99,145,152,0,0,0,0),
	('management',153,136,'admin/config/regional/date-time/formats/add','admin/config/regional/date-time/formats/add','Add format',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34333A22416C6C6F7720757365727320746F20616464206164646974696F6E616C206461746520666F726D6174732E223B7D7D','system',-1,0,0,0,-10,6,0,1,8,51,99,136,153,0,0,0,0),
	('management',154,133,'admin/structure/menu/manage/%/add','admin/structure/menu/manage/%/add','Add link',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,47,133,154,0,0,0,0,0),
	('management',155,30,'admin/structure/block/manage/%/%','admin/structure/block/manage/%/%','Configure block',X'613A303A7B7D','system',0,0,0,0,0,4,0,1,21,30,155,0,0,0,0,0,0),
	('navigation',156,31,'user/%/cancel/confirm/%/%','user/%/cancel/confirm/%/%','Confirm account cancellation',X'613A303A7B7D','system',0,0,0,0,0,3,0,17,31,156,0,0,0,0,0,0,0),
	('management',157,135,'admin/structure/types/manage/%/delete','admin/structure/types/manage/%/delete','Delete',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,21,36,135,157,0,0,0,0,0),
	('management',158,104,'admin/config/people/ip-blocking/delete/%','admin/config/people/ip-blocking/delete/%','Delete IP address',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,8,48,104,158,0,0,0,0,0),
	('management',159,91,'admin/config/system/actions/delete/%','admin/config/system/actions/delete/%','Delete action',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A31373A2244656C65746520616E20616374696F6E2E223B7D7D','system',0,0,0,0,0,5,0,1,8,56,91,159,0,0,0,0,0),
	('management',160,133,'admin/structure/menu/manage/%/delete','admin/structure/menu/manage/%/delete','Delete menu',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,21,47,133,160,0,0,0,0,0),
	('management',161,47,'admin/structure/menu/item/%/delete','admin/structure/menu/item/%/delete','Delete menu link',X'613A303A7B7D','system',0,0,0,0,0,4,0,1,21,47,161,0,0,0,0,0,0),
	('management',162,118,'admin/people/permissions/roles/delete/%','admin/people/permissions/roles/delete/%','Delete role',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,18,49,118,162,0,0,0,0,0),
	('management',163,127,'admin/config/content/formats/%/disable','admin/config/content/formats/%/disable','Disable text format',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,8,35,123,127,163,0,0,0,0),
	('management',164,135,'admin/structure/types/manage/%/edit','admin/structure/types/manage/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,36,135,164,0,0,0,0,0),
	('management',165,133,'admin/structure/menu/manage/%/edit','admin/structure/menu/manage/%/edit','Edit menu',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,47,133,165,0,0,0,0,0),
	('management',166,47,'admin/structure/menu/item/%/edit','admin/structure/menu/item/%/edit','Edit menu link',X'613A303A7B7D','system',0,0,0,0,0,4,0,1,21,47,166,0,0,0,0,0,0),
	('management',167,118,'admin/people/permissions/roles/edit/%','admin/people/permissions/roles/edit/%','Edit role',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,18,49,118,167,0,0,0,0,0),
	('management',168,105,'admin/config/media/image-styles/edit/%','admin/config/media/image-styles/edit/%','Edit style',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32353A22436F6E66696775726520616E20696D616765207374796C652E223B7D7D','system',0,0,1,0,0,5,0,1,8,46,105,168,0,0,0,0,0),
	('management',169,133,'admin/structure/menu/manage/%/list','admin/structure/menu/manage/%/list','List links',X'613A303A7B7D','system',-1,0,0,0,-10,5,0,1,21,47,133,169,0,0,0,0,0),
	('management',170,47,'admin/structure/menu/item/%/reset','admin/structure/menu/item/%/reset','Reset menu link',X'613A303A7B7D','system',0,0,0,0,0,4,0,1,21,47,170,0,0,0,0,0,0),
	('management',171,105,'admin/config/media/image-styles/delete/%','admin/config/media/image-styles/delete/%','Delete style',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32323A2244656C65746520616E20696D616765207374796C652E223B7D7D','system',0,0,0,0,0,5,0,1,8,46,105,171,0,0,0,0,0),
	('management',172,105,'admin/config/media/image-styles/revert/%','admin/config/media/image-styles/revert/%','Revert style',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32323A2252657665727420616E20696D616765207374796C652E223B7D7D','system',0,0,0,0,0,5,0,1,8,46,105,172,0,0,0,0,0),
	('management',173,135,'admin/structure/types/manage/%/comment/display','admin/structure/types/manage/%/comment/display','Comment display',X'613A303A7B7D','system',-1,0,0,0,4,5,0,1,21,36,135,173,0,0,0,0,0),
	('management',174,135,'admin/structure/types/manage/%/comment/fields','admin/structure/types/manage/%/comment/fields','Comment fields',X'613A303A7B7D','system',-1,0,1,0,3,5,0,1,21,36,135,174,0,0,0,0,0),
	('management',175,155,'admin/structure/block/manage/%/%/configure','admin/structure/block/manage/%/%/configure','Configure block',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,30,155,175,0,0,0,0,0),
	('management',176,155,'admin/structure/block/manage/%/%/delete','admin/structure/block/manage/%/%/delete','Delete block',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,21,30,155,176,0,0,0,0,0),
	('management',177,136,'admin/config/regional/date-time/formats/%/delete','admin/config/regional/date-time/formats/%/delete','Delete date format',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34373A22416C6C6F7720757365727320746F2064656C657465206120636F6E66696775726564206461746520666F726D61742E223B7D7D','system',0,0,0,0,0,6,0,1,8,51,99,136,177,0,0,0,0),
	('management',178,145,'admin/config/regional/date-time/types/%/delete','admin/config/regional/date-time/types/%/delete','Delete date type',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34353A22416C6C6F7720757365727320746F2064656C657465206120636F6E66696775726564206461746520747970652E223B7D7D','system',0,0,0,0,0,6,0,1,8,51,99,145,178,0,0,0,0),
	('management',179,136,'admin/config/regional/date-time/formats/%/edit','admin/config/regional/date-time/formats/%/edit','Edit date format',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34353A22416C6C6F7720757365727320746F2065646974206120636F6E66696775726564206461746520666F726D61742E223B7D7D','system',0,0,0,0,0,6,0,1,8,51,99,136,179,0,0,0,0),
	('management',180,168,'admin/config/media/image-styles/edit/%/add/%','admin/config/media/image-styles/edit/%/add/%','Add image effect',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32383A224164642061206E65772065666665637420746F2061207374796C652E223B7D7D','system',0,0,0,0,0,6,0,1,8,46,105,168,180,0,0,0,0),
	('management',181,168,'admin/config/media/image-styles/edit/%/effects/%','admin/config/media/image-styles/edit/%/effects/%','Edit image effect',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33393A224564697420616E206578697374696E67206566666563742077697468696E2061207374796C652E223B7D7D','system',0,0,1,0,0,6,0,1,8,46,105,168,181,0,0,0,0),
	('management',182,181,'admin/config/media/image-styles/edit/%/effects/%/delete','admin/config/media/image-styles/edit/%/effects/%/delete','Delete image effect',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33393A2244656C65746520616E206578697374696E67206566666563742066726F6D2061207374796C652E223B7D7D','system',0,0,0,0,0,7,0,1,8,46,105,168,181,182,0,0,0),
	('management',183,47,'admin/structure/menu/manage/main-menu','admin/structure/menu/manage/%','Main menu',X'613A303A7B7D','menu',0,0,0,0,0,4,0,1,21,47,183,0,0,0,0,0,0),
	('management',184,47,'admin/structure/menu/manage/management','admin/structure/menu/manage/%','Management',X'613A303A7B7D','menu',0,0,0,0,0,4,0,1,21,47,184,0,0,0,0,0,0),
	('management',185,47,'admin/structure/menu/manage/navigation','admin/structure/menu/manage/%','Navigation',X'613A303A7B7D','menu',0,0,0,0,0,4,0,1,21,47,185,0,0,0,0,0,0),
	('management',186,47,'admin/structure/menu/manage/user-menu','admin/structure/menu/manage/%','User menu',X'613A303A7B7D','menu',0,0,0,0,0,4,0,1,21,47,186,0,0,0,0,0,0),
	('navigation',187,0,'search','search','Search',X'613A303A7B7D','system',1,0,0,0,0,1,0,187,0,0,0,0,0,0,0,0,0),
	('navigation',188,187,'search/node','search/node','Content',X'613A303A7B7D','system',-1,0,0,0,-10,2,0,187,188,0,0,0,0,0,0,0,0),
	('navigation',189,187,'search/user','search/user','Users',X'613A303A7B7D','system',-1,0,0,0,0,2,0,187,189,0,0,0,0,0,0,0,0),
	('navigation',190,188,'search/node/%','search/node/%','Content',X'613A303A7B7D','system',-1,0,0,0,0,3,0,187,188,190,0,0,0,0,0,0,0),
	('navigation',191,17,'user/%/shortcuts','user/%/shortcuts','Shortcuts',X'613A303A7B7D','system',-1,0,0,0,0,2,0,17,191,0,0,0,0,0,0,0,0),
	('management',192,19,'admin/reports/search','admin/reports/search','Top search phrases',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A33333A2256696577206D6F737420706F70756C61722073656172636820706872617365732E223B7D7D','system',0,0,0,0,0,3,0,1,19,192,0,0,0,0,0,0,0),
	('navigation',193,189,'search/user/%','search/user/%','Users',X'613A303A7B7D','system',-1,0,0,0,0,3,0,187,189,193,0,0,0,0,0,0,0),
	('management',194,12,'admin/help/number','admin/help/number','number',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,194,0,0,0,0,0,0,0),
	('management',195,12,'admin/help/overlay','admin/help/overlay','overlay',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,195,0,0,0,0,0,0,0),
	('management',196,12,'admin/help/path','admin/help/path','path',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,196,0,0,0,0,0,0,0),
	('management',197,12,'admin/help/rdf','admin/help/rdf','rdf',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,197,0,0,0,0,0,0,0),
	('management',198,12,'admin/help/search','admin/help/search','search',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,198,0,0,0,0,0,0,0),
	('management',199,12,'admin/help/shortcut','admin/help/shortcut','shortcut',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,199,0,0,0,0,0,0,0),
	('management',200,53,'admin/config/search/settings','admin/config/search/settings','Search settings',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A36373A22436F6E6669677572652072656C6576616E63652073657474696E677320666F722073656172636820616E64206F7468657220696E646578696E67206F7074696F6E732E223B7D7D','system',0,0,0,0,-10,4,0,1,8,53,200,0,0,0,0,0,0),
	('management',201,61,'admin/config/user-interface/shortcut','admin/config/user-interface/shortcut','Shortcuts',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A32393A2241646420616E64206D6F646966792073686F727463757420736574732E223B7D7D','system',0,0,1,0,0,4,0,1,8,61,201,0,0,0,0,0,0),
	('management',202,53,'admin/config/search/path','admin/config/search/path','URL aliases',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A34363A224368616E676520796F7572207369746527732055524C20706174687320627920616C696173696E67207468656D2E223B7D7D','system',0,0,1,0,-5,4,0,1,8,53,202,0,0,0,0,0,0),
	('management',203,202,'admin/config/search/path/add','admin/config/search/path/add','Add alias',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,8,53,202,203,0,0,0,0,0),
	('management',204,201,'admin/config/user-interface/shortcut/add-set','admin/config/user-interface/shortcut/add-set','Add shortcut set',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,8,61,201,204,0,0,0,0,0),
	('management',205,200,'admin/config/search/settings/reindex','admin/config/search/settings/reindex','Clear index',X'613A303A7B7D','system',-1,0,0,0,0,5,0,1,8,53,200,205,0,0,0,0,0),
	('management',206,201,'admin/config/user-interface/shortcut/%','admin/config/user-interface/shortcut/%','Edit shortcuts',X'613A303A7B7D','system',0,0,1,0,0,5,0,1,8,61,201,206,0,0,0,0,0),
	('management',207,202,'admin/config/search/path/list','admin/config/search/path/list','List',X'613A303A7B7D','system',-1,0,0,0,-10,5,0,1,8,53,202,207,0,0,0,0,0),
	('management',208,206,'admin/config/user-interface/shortcut/%/add-link','admin/config/user-interface/shortcut/%/add-link','Add shortcut',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,8,61,201,206,208,0,0,0,0),
	('management',209,202,'admin/config/search/path/delete/%','admin/config/search/path/delete/%','Delete alias',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,8,53,202,209,0,0,0,0,0),
	('management',210,206,'admin/config/user-interface/shortcut/%/delete','admin/config/user-interface/shortcut/%/delete','Delete shortcut set',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,8,61,201,206,210,0,0,0,0),
	('management',211,202,'admin/config/search/path/edit/%','admin/config/search/path/edit/%','Edit alias',X'613A303A7B7D','system',0,0,0,0,0,5,0,1,8,53,202,211,0,0,0,0,0),
	('management',212,206,'admin/config/user-interface/shortcut/%/edit','admin/config/user-interface/shortcut/%/edit','Edit set name',X'613A303A7B7D','system',-1,0,0,0,10,6,0,1,8,61,201,206,212,0,0,0,0),
	('management',213,201,'admin/config/user-interface/shortcut/link/%','admin/config/user-interface/shortcut/link/%','Edit shortcut',X'613A303A7B7D','system',0,0,1,0,0,5,0,1,8,61,201,213,0,0,0,0,0),
	('management',214,206,'admin/config/user-interface/shortcut/%/links','admin/config/user-interface/shortcut/%/links','List links',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,8,61,201,206,214,0,0,0,0),
	('management',215,213,'admin/config/user-interface/shortcut/link/%/delete','admin/config/user-interface/shortcut/link/%/delete','Delete shortcut',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,8,61,201,213,215,0,0,0,0),
	('shortcut-set-1',216,0,'node/add','node/add','Add content',X'613A303A7B7D','menu',0,0,0,0,-20,1,0,216,0,0,0,0,0,0,0,0,0),
	('shortcut-set-1',217,0,'admin/content','admin/content','Find content',X'613A303A7B7D','menu',0,0,0,0,-19,1,0,217,0,0,0,0,0,0,0,0,0),
	('main-menu',218,0,'<front>','','Home',X'613A303A7B7D','menu',0,1,0,0,0,1,0,218,0,0,0,0,0,0,0,0,0),
	('navigation',219,6,'node/add/article','node/add/article','Article',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A38393A22557365203C656D3E61727469636C65733C2F656D3E20666F722074696D652D73656E73697469766520636F6E74656E74206C696B65206E6577732C2070726573732072656C6561736573206F7220626C6F6720706F7374732E223B7D7D','system',0,0,0,0,0,2,0,6,219,0,0,0,0,0,0,0,0),
	('navigation',220,6,'node/add/page','node/add/page','Basic page',X'613A313A7B733A31303A2261747472696275746573223B613A313A7B733A353A227469746C65223B733A37373A22557365203C656D3E62617369632070616765733C2F656D3E20666F7220796F75722073746174696320636F6E74656E742C207375636820617320616E202741626F75742075732720706167652E223B7D7D','system',0,0,0,0,0,2,0,6,220,0,0,0,0,0,0,0,0),
	('management',221,12,'admin/help/toolbar','admin/help/toolbar','toolbar',X'613A303A7B7D','system',-1,0,0,0,0,3,0,1,12,221,0,0,0,0,0,0,0),
	('management',260,89,'admin/structure/taxonomy/%/display','admin/structure/taxonomy/%/display','Manage display',X'613A303A7B7D','system',-1,0,0,0,2,5,0,1,21,57,89,260,0,0,0,0,0),
	('management',261,90,'admin/config/people/accounts/display','admin/config/people/accounts/display','Manage display',X'613A303A7B7D','system',-1,0,0,0,2,5,0,1,8,48,90,261,0,0,0,0,0),
	('management',262,89,'admin/structure/taxonomy/%/fields','admin/structure/taxonomy/%/fields','Manage fields',X'613A303A7B7D','system',-1,0,1,0,1,5,0,1,21,57,89,262,0,0,0,0,0),
	('management',263,90,'admin/config/people/accounts/fields','admin/config/people/accounts/fields','Manage fields',X'613A303A7B7D','system',-1,0,1,0,1,5,0,1,8,48,90,263,0,0,0,0,0),
	('management',264,260,'admin/structure/taxonomy/%/display/default','admin/structure/taxonomy/%/display/default','Default',X'613A303A7B7D','system',-1,0,0,0,-10,6,0,1,21,57,89,260,264,0,0,0,0),
	('management',265,261,'admin/config/people/accounts/display/default','admin/config/people/accounts/display/default','Default',X'613A303A7B7D','system',-1,0,0,0,-10,6,0,1,8,48,90,261,265,0,0,0,0),
	('management',266,135,'admin/structure/types/manage/%/display','admin/structure/types/manage/%/display','Manage display',X'613A303A7B7D','system',-1,0,0,0,2,5,0,1,21,36,135,266,0,0,0,0,0),
	('management',267,135,'admin/structure/types/manage/%/fields','admin/structure/types/manage/%/fields','Manage fields',X'613A303A7B7D','system',-1,0,1,0,1,5,0,1,21,36,135,267,0,0,0,0,0),
	('management',268,260,'admin/structure/taxonomy/%/display/full','admin/structure/taxonomy/%/display/full','Taxonomy term page',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,21,57,89,260,268,0,0,0,0),
	('management',269,261,'admin/config/people/accounts/display/full','admin/config/people/accounts/display/full','User account',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,8,48,90,261,269,0,0,0,0),
	('management',270,262,'admin/structure/taxonomy/%/fields/%','admin/structure/taxonomy/%/fields/%','',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,21,57,89,262,270,0,0,0,0),
	('management',271,263,'admin/config/people/accounts/fields/%','admin/config/people/accounts/fields/%','',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,8,48,90,263,271,0,0,0,0),
	('management',272,266,'admin/structure/types/manage/%/display/default','admin/structure/types/manage/%/display/default','Default',X'613A303A7B7D','system',-1,0,0,0,-10,6,0,1,21,36,135,266,272,0,0,0,0),
	('management',273,266,'admin/structure/types/manage/%/display/full','admin/structure/types/manage/%/display/full','Full content',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,21,36,135,266,273,0,0,0,0),
	('management',274,266,'admin/structure/types/manage/%/display/rss','admin/structure/types/manage/%/display/rss','RSS',X'613A303A7B7D','system',-1,0,0,0,2,6,0,1,21,36,135,266,274,0,0,0,0),
	('management',275,266,'admin/structure/types/manage/%/display/search_index','admin/structure/types/manage/%/display/search_index','Search index',X'613A303A7B7D','system',-1,0,0,0,3,6,0,1,21,36,135,266,275,0,0,0,0),
	('management',276,266,'admin/structure/types/manage/%/display/search_result','admin/structure/types/manage/%/display/search_result','Search result highlighting input',X'613A303A7B7D','system',-1,0,0,0,4,6,0,1,21,36,135,266,276,0,0,0,0),
	('management',277,266,'admin/structure/types/manage/%/display/teaser','admin/structure/types/manage/%/display/teaser','Teaser',X'613A303A7B7D','system',-1,0,0,0,1,6,0,1,21,36,135,266,277,0,0,0,0),
	('management',278,267,'admin/structure/types/manage/%/fields/%','admin/structure/types/manage/%/fields/%','',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,21,36,135,267,278,0,0,0,0),
	('management',279,270,'admin/structure/taxonomy/%/fields/%/delete','admin/structure/taxonomy/%/fields/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,10,7,0,1,21,57,89,262,270,279,0,0,0),
	('management',280,270,'admin/structure/taxonomy/%/fields/%/edit','admin/structure/taxonomy/%/fields/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,57,89,262,270,280,0,0,0),
	('management',281,270,'admin/structure/taxonomy/%/fields/%/field-settings','admin/structure/taxonomy/%/fields/%/field-settings','Field settings',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,57,89,262,270,281,0,0,0),
	('management',282,270,'admin/structure/taxonomy/%/fields/%/widget-type','admin/structure/taxonomy/%/fields/%/widget-type','Widget type',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,57,89,262,270,282,0,0,0),
	('management',283,271,'admin/config/people/accounts/fields/%/delete','admin/config/people/accounts/fields/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,10,7,0,1,8,48,90,263,271,283,0,0,0),
	('management',284,271,'admin/config/people/accounts/fields/%/edit','admin/config/people/accounts/fields/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,8,48,90,263,271,284,0,0,0),
	('management',285,271,'admin/config/people/accounts/fields/%/field-settings','admin/config/people/accounts/fields/%/field-settings','Field settings',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,8,48,90,263,271,285,0,0,0),
	('management',286,271,'admin/config/people/accounts/fields/%/widget-type','admin/config/people/accounts/fields/%/widget-type','Widget type',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,8,48,90,263,271,286,0,0,0),
	('management',287,173,'admin/structure/types/manage/%/comment/display/default','admin/structure/types/manage/%/comment/display/default','Default',X'613A303A7B7D','system',-1,0,0,0,-10,6,0,1,21,36,135,173,287,0,0,0,0),
	('management',288,173,'admin/structure/types/manage/%/comment/display/full','admin/structure/types/manage/%/comment/display/full','Full comment',X'613A303A7B7D','system',-1,0,0,0,0,6,0,1,21,36,135,173,288,0,0,0,0),
	('management',289,174,'admin/structure/types/manage/%/comment/fields/%','admin/structure/types/manage/%/comment/fields/%','',X'613A303A7B7D','system',0,0,0,0,0,6,0,1,21,36,135,174,289,0,0,0,0),
	('management',290,278,'admin/structure/types/manage/%/fields/%/delete','admin/structure/types/manage/%/fields/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,10,7,0,1,21,36,135,267,278,290,0,0,0),
	('management',291,278,'admin/structure/types/manage/%/fields/%/edit','admin/structure/types/manage/%/fields/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,267,278,291,0,0,0),
	('management',292,278,'admin/structure/types/manage/%/fields/%/field-settings','admin/structure/types/manage/%/fields/%/field-settings','Field settings',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,267,278,292,0,0,0),
	('management',293,278,'admin/structure/types/manage/%/fields/%/widget-type','admin/structure/types/manage/%/fields/%/widget-type','Widget type',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,267,278,293,0,0,0),
	('management',294,289,'admin/structure/types/manage/%/comment/fields/%/delete','admin/structure/types/manage/%/comment/fields/%/delete','Delete',X'613A303A7B7D','system',-1,0,0,0,10,7,0,1,21,36,135,174,289,294,0,0,0),
	('management',295,289,'admin/structure/types/manage/%/comment/fields/%/edit','admin/structure/types/manage/%/comment/fields/%/edit','Edit',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,174,289,295,0,0,0),
	('management',296,289,'admin/structure/types/manage/%/comment/fields/%/field-settings','admin/structure/types/manage/%/comment/fields/%/field-settings','Field settings',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,174,289,296,0,0,0),
	('management',297,289,'admin/structure/types/manage/%/comment/fields/%/widget-type','admin/structure/types/manage/%/comment/fields/%/widget-type','Widget type',X'613A303A7B7D','system',-1,0,0,0,0,7,0,1,21,36,135,174,289,297,0,0,0);

/*!40000 ALTER TABLE `menu_links` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table menu_router
# ------------------------------------------------------------

DROP TABLE IF EXISTS `menu_router`;

CREATE TABLE `menu_router` (
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: the Drupal path this entry describes',
  `load_functions` blob NOT NULL COMMENT 'A serialized array of function names (like node_load) to be called to load an object corresponding to a part of the current path.',
  `to_arg_functions` blob NOT NULL COMMENT 'A serialized array of function names (like user_uid_optional_to_arg) to be called to replace a part of the router path with another string.',
  `access_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The callback which determines the access to this router path. Defaults to user_access.',
  `access_arguments` blob COMMENT 'A serialized array of arguments for the access callback.',
  `page_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function that renders the page.',
  `page_arguments` blob COMMENT 'A serialized array of arguments for the page callback.',
  `delivery_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function that sends the result of the page_callback function to the browser.',
  `fit` int(11) NOT NULL DEFAULT '0' COMMENT 'A numeric representation of how specific the path is.',
  `number_parts` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Number of parts in this router path.',
  `context` int(11) NOT NULL DEFAULT '0' COMMENT 'Only for local tasks (tabs) - the context of a local task to control its placement.',
  `tab_parent` varchar(255) NOT NULL DEFAULT '' COMMENT 'Only for local tasks (tabs) - the router path of the parent page (which may also be a local task).',
  `tab_root` varchar(255) NOT NULL DEFAULT '' COMMENT 'Router path of the closest non-tab parent page. For pages that are not local tasks, this will be the same as the path.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title for the current page, or the title for the tab if this is a local task.',
  `title_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'A function which will alter the title. Defaults to t()',
  `title_arguments` varchar(255) NOT NULL DEFAULT '' COMMENT 'A serialized array of arguments for the title callback. If empty, the title will be used as the sole argument for the title callback.',
  `theme_callback` varchar(255) NOT NULL DEFAULT '' COMMENT 'A function which returns the name of the theme that will be used to render this page. If left empty, the default theme will be used.',
  `theme_arguments` varchar(255) NOT NULL DEFAULT '' COMMENT 'A serialized array of arguments for the theme callback.',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT 'Numeric representation of the type of the menu item, like MENU_LOCAL_TASK.',
  `description` text NOT NULL COMMENT 'A description of this item.',
  `position` varchar(255) NOT NULL DEFAULT '' COMMENT 'The position of the block (left or right) on the system administration page for this item.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'Weight of the element. Lighter weights are higher up, heavier weights go down.',
  `include_file` mediumtext COMMENT 'The file to include for this element, usually the page callback function lives in this file.',
  PRIMARY KEY (`path`),
  KEY `fit` (`fit`),
  KEY `tab_parent` (`tab_parent`(64),`weight`,`title`),
  KEY `tab_root_weight_title` (`tab_root`(64),`weight`,`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps paths to various callbacks (access, page and title)';

LOCK TABLES `menu_router` WRITE;
/*!40000 ALTER TABLE `menu_router` DISABLE KEYS */;

INSERT INTO `menu_router` (`path`, `load_functions`, `to_arg_functions`, `access_callback`, `access_arguments`, `page_callback`, `page_arguments`, `delivery_callback`, `fit`, `number_parts`, `context`, `tab_parent`, `tab_root`, `title`, `title_callback`, `title_arguments`, `theme_callback`, `theme_arguments`, `type`, `description`, `position`, `weight`, `include_file`)
VALUES
	('admin','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',1,1,0,'','admin','Administration','t','','','a:0:{}',6,'','',9,'modules/system/system.admin.inc'),
	('admin/appearance','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','system_themes_page',X'613A303A7B7D','',3,2,0,'','admin/appearance','Appearance','t','','','a:0:{}',6,'Select and configure your themes.','left',-6,'modules/system/system.admin.inc'),
	('admin/appearance/default','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','system_theme_default',X'613A303A7B7D','',7,3,0,'','admin/appearance/default','Set default theme','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/disable','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','system_theme_disable',X'613A303A7B7D','',7,3,0,'','admin/appearance/disable','Disable theme','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/enable','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','system_theme_enable',X'613A303A7B7D','',7,3,0,'','admin/appearance/enable','Enable theme','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/list','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','system_themes_page',X'613A303A7B7D','',7,3,1,'admin/appearance','admin/appearance','List','t','','','a:0:{}',140,'Select and configure your theme','',-1,'modules/system/system.admin.inc'),
	('admin/appearance/settings','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B7D','',7,3,1,'admin/appearance','admin/appearance','Settings','t','','','a:0:{}',132,'Configure default and theme specific settings.','',20,'modules/system/system.admin.inc'),
	('admin/appearance/settings/bartik','','','_system_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32353A227468656D65732F62617274696B2F62617274696B2E696E666F223B733A343A226E616D65223B733A363A2262617274696B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A363A2242617274696B223B733A31313A226465736372697074696F6E223B733A34383A224120666C657869626C652C207265636F6C6F7261626C65207468656D652077697468206D616E7920726567696F6E732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A373A22726567696F6E73223B613A32303A7B733A363A22686561646572223B733A363A22486561646572223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A383A226665617475726564223B733A383A224665617475726564223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A31333A22736964656261725F6669727374223B733A31333A2253696465626172206669727374223B733A31343A22736964656261725F7365636F6E64223B733A31343A2253696465626172207365636F6E64223B733A31343A2274726970747963685F6669727374223B733A31343A225472697074796368206669727374223B733A31353A2274726970747963685F6D6964646C65223B733A31353A225472697074796368206D6964646C65223B733A31333A2274726970747963685F6C617374223B733A31333A225472697074796368206C617374223B733A31383A22666F6F7465725F6669727374636F6C756D6E223B733A31393A22466F6F74657220666972737420636F6C756D6E223B733A31393A22666F6F7465725F7365636F6E64636F6C756D6E223B733A32303A22466F6F746572207365636F6E6420636F6C756D6E223B733A31383A22666F6F7465725F7468697264636F6C756D6E223B733A31393A22466F6F74657220746869726420636F6C756D6E223B733A31393A22666F6F7465725F666F75727468636F6C756D6E223B733A32303A22466F6F74657220666F7572746820636F6C756D6E223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2230223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32383A227468656D65732F62617274696B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','drupal_get_form',X'613A323A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B693A313B733A363A2262617274696B223B7D','',15,4,1,'admin/appearance/settings','admin/appearance','Bartik','t','','','a:0:{}',132,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/settings/garland','','','_system_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32373A227468656D65732F6761726C616E642F6761726C616E642E696E666F223B733A343A226E616D65223B733A373A226761726C616E64223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A373A224761726C616E64223B733A31313A226465736372697074696F6E223B733A3131313A2241206D756C74692D636F6C756D6E207468656D652077686963682063616E20626520636F6E6669677572656420746F206D6F6469667920636F6C6F727320616E6420737769746368206265747765656E20666978656420616E6420666C756964207769647468206C61796F7574732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A31333A226761726C616E645F7769647468223B733A353A22666C756964223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32393A227468656D65732F6761726C616E642F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','drupal_get_form',X'613A323A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B693A313B733A373A226761726C616E64223B7D','',15,4,1,'admin/appearance/settings','admin/appearance','Garland','t','','','a:0:{}',132,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/settings/global','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E6973746572207468656D6573223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B7D','',15,4,1,'admin/appearance/settings','admin/appearance','Global settings','t','','','a:0:{}',140,'','',-1,'modules/system/system.admin.inc'),
	('admin/appearance/settings/seven','','','_system_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F736576656E2F736576656E2E696E666F223B733A343A226E616D65223B733A353A22736576656E223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A353A22536576656E223B733A31313A226465736372697074696F6E223B733A36353A22412073696D706C65206F6E652D636F6C756D6E2C207461626C656C6573732C20666C7569642077696474682061646D696E697374726174696F6E207468656D652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2231223B7D733A373A22726567696F6E73223B613A383A7B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31333A22736964656261725F6669727374223B733A31333A2246697273742073696465626172223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A31343A22726567696F6E735F68696464656E223B613A333A7B693A303B733A31333A22736964656261725F6669727374223B693A313B733A383A22706167655F746F70223B693A323B733A31313A22706167655F626F74746F6D223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F736576656E2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','drupal_get_form',X'613A323A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B693A313B733A353A22736576656E223B7D','',15,4,1,'admin/appearance/settings','admin/appearance','Seven','t','','','a:0:{}',132,'','',0,'modules/system/system.admin.inc'),
	('admin/appearance/settings/stark','','','_system_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F737461726B2F737461726B2E696E666F223B733A343A226E616D65223B733A353A22737461726B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31383A7B733A343A226E616D65223B733A353A22537461726B223B733A31313A226465736372697074696F6E223B733A3230383A2254686973207468656D652064656D6F6E737472617465732044727570616C27732064656661756C742048544D4C206D61726B757020616E6420435353207374796C65732E20546F206C6561726E20686F7720746F206275696C6420796F7572206F776E207468656D6520616E64206F766572726964652044727570616C27732064656661756C7420636F64652C2073656520746865203C6120687265663D22687474703A2F2F64727570616C2E6F72672F7468656D652D6775696465223E5468656D696E672047756964653C2F613E2E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F737461726B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','drupal_get_form',X'613A323A7B693A303B733A32313A2273797374656D5F7468656D655F73657474696E6773223B693A313B733A353A22737461726B223B7D','',15,4,1,'admin/appearance/settings','admin/appearance','Stark','t','','','a:0:{}',132,'','',0,'modules/system/system.admin.inc'),
	('admin/compact','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_compact_page',X'613A303A7B7D','',3,2,0,'','admin/compact','Compact mode','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/config','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_config_page',X'613A303A7B7D','',3,2,0,'','admin/config','Configuration','t','','','a:0:{}',6,'Administer settings.','',0,'modules/system/system.admin.inc'),
	('admin/config/content','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/content','Content authoring','t','','','a:0:{}',6,'Settings related to formatting and authoring content.','left',-15,'modules/system/system.admin.inc'),
	('admin/config/content/formats','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E69737465722066696C74657273223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A2266696C7465725F61646D696E5F6F76657276696577223B7D','',15,4,0,'','admin/config/content/formats','Text formats','t','','','a:0:{}',6,'Configure how content input by users is filtered, including allowed HTML tags. Also allows enabling of module-provided filters.','',0,'modules/filter/filter.admin.inc'),
	('admin/config/content/formats/%',X'613A313A7B693A343B733A31383A2266696C7465725F666F726D61745F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31383A2261646D696E69737465722066696C74657273223B7D','filter_admin_format_page',X'613A313A7B693A303B693A343B7D','',30,5,0,'','admin/config/content/formats/%','','filter_admin_format_title','a:1:{i:0;i:4;}','','a:0:{}',6,'','',0,'modules/filter/filter.admin.inc'),
	('admin/config/content/formats/%/disable',X'613A313A7B693A343B733A31383A2266696C7465725F666F726D61745F6C6F6164223B7D','','_filter_disable_format_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A32303A2266696C7465725F61646D696E5F64697361626C65223B693A313B693A343B7D','',61,6,0,'','admin/config/content/formats/%/disable','Disable text format','t','','','a:0:{}',6,'','',0,'modules/filter/filter.admin.inc'),
	('admin/config/content/formats/add','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E69737465722066696C74657273223B7D','filter_admin_format_page',X'613A303A7B7D','',31,5,1,'admin/config/content/formats','admin/config/content/formats','Add text format','t','','','a:0:{}',388,'','',1,'modules/filter/filter.admin.inc'),
	('admin/config/content/formats/list','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E69737465722066696C74657273223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A2266696C7465725F61646D696E5F6F76657276696577223B7D','',31,5,1,'admin/config/content/formats','admin/config/content/formats','List','t','','','a:0:{}',140,'','',0,'modules/filter/filter.admin.inc'),
	('admin/config/development','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/development','Development','t','','','a:0:{}',6,'Development tools.','right',-10,'modules/system/system.admin.inc'),
	('admin/config/development/logging','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32333A2273797374656D5F6C6F6767696E675F73657474696E6773223B7D','',15,4,0,'','admin/config/development/logging','Logging and errors','t','','','a:0:{}',6,'Settings for logging and alerts modules. Various modules can route Drupal\'s system events to different destinations, such as syslog, database, email, etc.','',-15,'modules/system/system.admin.inc'),
	('admin/config/development/maintenance','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32383A2273797374656D5F736974655F6D61696E74656E616E63655F6D6F6465223B7D','',15,4,0,'','admin/config/development/maintenance','Maintenance mode','t','','','a:0:{}',6,'Take the site offline for maintenance or bring it back online.','',-10,'modules/system/system.admin.inc'),
	('admin/config/development/performance','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32373A2273797374656D5F706572666F726D616E63655F73657474696E6773223B7D','',15,4,0,'','admin/config/development/performance','Performance','t','','','a:0:{}',6,'Enable or disable page caching for anonymous users and set CSS and JS bandwidth optimization options.','',-20,'modules/system/system.admin.inc'),
	('admin/config/media','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/media','Media','t','','','a:0:{}',6,'Media tools.','left',-10,'modules/system/system.admin.inc'),
	('admin/config/media/file-system','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32373A2273797374656D5F66696C655F73797374656D5F73657474696E6773223B7D','',15,4,0,'','admin/config/media/file-system','File system','t','','','a:0:{}',6,'Tell Drupal where to store uploaded files and how they are accessed.','',-10,'modules/system/system.admin.inc'),
	('admin/config/media/image-styles','','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','image_style_list',X'613A303A7B7D','',15,4,0,'','admin/config/media/image-styles','Image styles','t','','','a:0:{}',6,'Configure styles that can be used for resizing or adjusting images on display.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/add','','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A22696D6167655F7374796C655F6164645F666F726D223B7D','',31,5,1,'admin/config/media/image-styles','admin/config/media/image-styles','Add style','t','','','a:0:{}',388,'Add a new image style.','',2,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/delete/%',X'613A313A7B693A353B613A313A7B733A31363A22696D6167655F7374796C655F6C6F6164223B613A323A7B693A303B4E3B693A313B733A313A2231223B7D7D7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A323A7B693A303B733A32333A22696D6167655F7374796C655F64656C6574655F666F726D223B693A313B693A353B7D','',62,6,0,'','admin/config/media/image-styles/delete/%','Delete style','t','','','a:0:{}',6,'Delete an image style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/edit/%',X'613A313A7B693A353B733A31363A22696D6167655F7374796C655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A323A7B693A303B733A31363A22696D6167655F7374796C655F666F726D223B693A313B693A353B7D','',62,6,0,'','admin/config/media/image-styles/edit/%','Edit style','t','','','a:0:{}',6,'Configure an image style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/edit/%/add/%',X'613A323A7B693A353B613A313A7B733A31363A22696D6167655F7374796C655F6C6F6164223B613A313A7B693A303B693A353B7D7D693A373B613A313A7B733A32383A22696D6167655F6566666563745F646566696E6974696F6E5F6C6F6164223B613A313A7B693A303B693A353B7D7D7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A333A7B693A303B733A31373A22696D6167655F6566666563745F666F726D223B693A313B693A353B693A323B693A373B7D','',250,8,0,'','admin/config/media/image-styles/edit/%/add/%','Add image effect','t','','','a:0:{}',6,'Add a new effect to a style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/edit/%/effects/%',X'613A323A7B693A353B613A313A7B733A31363A22696D6167655F7374796C655F6C6F6164223B613A323A7B693A303B693A353B693A313B733A313A2233223B7D7D693A373B613A313A7B733A31373A22696D6167655F6566666563745F6C6F6164223B613A323A7B693A303B693A353B693A313B733A313A2233223B7D7D7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A333A7B693A303B733A31373A22696D6167655F6566666563745F666F726D223B693A313B693A353B693A323B693A373B7D','',250,8,0,'','admin/config/media/image-styles/edit/%/effects/%','Edit image effect','t','','','a:0:{}',6,'Edit an existing effect within a style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/edit/%/effects/%/delete',X'613A323A7B693A353B613A313A7B733A31363A22696D6167655F7374796C655F6C6F6164223B613A323A7B693A303B693A353B693A313B733A313A2233223B7D7D693A373B613A313A7B733A31373A22696D6167655F6566666563745F6C6F6164223B613A323A7B693A303B693A353B693A313B733A313A2233223B7D7D7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A333A7B693A303B733A32343A22696D6167655F6566666563745F64656C6574655F666F726D223B693A313B693A353B693A323B693A373B7D','',501,9,0,'','admin/config/media/image-styles/edit/%/effects/%/delete','Delete image effect','t','','','a:0:{}',6,'Delete an existing effect from a style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/list','','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','image_style_list',X'613A303A7B7D','',31,5,1,'admin/config/media/image-styles','admin/config/media/image-styles','List','t','','','a:0:{}',140,'List the current image styles on the site.','',1,'modules/image/image.admin.inc'),
	('admin/config/media/image-styles/revert/%',X'613A313A7B693A353B613A313A7B733A31363A22696D6167655F7374796C655F6C6F6164223B613A323A7B693A303B4E3B693A313B733A313A2232223B7D7D7D','','user_access',X'613A313A7B693A303B733A32333A2261646D696E697374657220696D616765207374796C6573223B7D','drupal_get_form',X'613A323A7B693A303B733A32333A22696D6167655F7374796C655F7265766572745F666F726D223B693A313B693A353B7D','',62,6,0,'','admin/config/media/image-styles/revert/%','Revert style','t','','','a:0:{}',6,'Revert an image style.','',0,'modules/image/image.admin.inc'),
	('admin/config/media/image-toolkit','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32393A2273797374656D5F696D6167655F746F6F6C6B69745F73657474696E6773223B7D','',15,4,0,'','admin/config/media/image-toolkit','Image toolkit','t','','','a:0:{}',6,'Choose which image toolkit to use if you have installed optional toolkits.','',20,'modules/system/system.admin.inc'),
	('admin/config/people','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/people','People','t','','','a:0:{}',6,'Configure user accounts.','left',-20,'modules/system/system.admin.inc'),
	('admin/config/people/accounts','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A313A7B693A303B733A31393A22757365725F61646D696E5F73657474696E6773223B7D','',15,4,0,'','admin/config/people/accounts','Account settings','t','','','a:0:{}',6,'Configure default behavior of users, including registration requirements, e-mails, fields, and user pictures.','',-10,'modules/user/user.admin.inc'),
	('admin/config/people/accounts/display','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A2275736572223B693A323B733A343A2275736572223B693A333B733A373A2264656661756C74223B7D','',31,5,1,'admin/config/people/accounts','admin/config/people/accounts','Manage display','t','','','a:0:{}',132,'','',2,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/display/default','','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A373A2264656661756C74223B693A333B733A31313A22757365725F616363657373223B693A343B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A2275736572223B693A323B733A343A2275736572223B693A333B733A373A2264656661756C74223B7D','',63,6,1,'admin/config/people/accounts/display','admin/config/people/accounts','Default','t','','','a:0:{}',140,'','',-10,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/display/full','','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A343A2266756C6C223B693A333B733A31313A22757365725F616363657373223B693A343B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A2275736572223B693A323B733A343A2275736572223B693A333B733A343A2266756C6C223B7D','',63,6,1,'admin/config/people/accounts/display','admin/config/people/accounts','User account','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A333A7B693A303B733A32383A226669656C645F75695F6669656C645F6F766572766965775F666F726D223B693A313B733A343A2275736572223B693A323B733A343A2275736572223B7D','',31,5,1,'admin/config/people/accounts','admin/config/people/accounts','Manage fields','t','','','a:0:{}',132,'','',1,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields/%',X'613A313A7B693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A313A2230223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A353B7D','',62,6,0,'','admin/config/people/accounts/fields/%','','field_ui_menu_title','a:1:{i:0;i:5;}','','a:0:{}',6,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields/%/delete',X'613A313A7B693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A313A2230223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A323A7B693A303B733A32363A226669656C645F75695F6669656C645F64656C6574655F666F726D223B693A313B693A353B7D','',125,7,1,'admin/config/people/accounts/fields/%','admin/config/people/accounts/fields/%','Delete','t','','','a:0:{}',132,'','',10,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields/%/edit',X'613A313A7B693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A313A2230223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A353B7D','',125,7,1,'admin/config/people/accounts/fields/%','admin/config/people/accounts/fields/%','Edit','t','','','a:0:{}',140,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields/%/field-settings',X'613A313A7B693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A313A2230223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226669656C645F75695F6669656C645F73657474696E67735F666F726D223B693A313B693A353B7D','',125,7,1,'admin/config/people/accounts/fields/%','admin/config/people/accounts/fields/%','Field settings','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/fields/%/widget-type',X'613A313A7B693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A2275736572223B693A313B733A343A2275736572223B693A323B733A313A2230223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A226669656C645F75695F7769646765745F747970655F666F726D223B693A313B693A353B7D','',125,7,1,'admin/config/people/accounts/fields/%','admin/config/people/accounts/fields/%','Widget type','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/config/people/accounts/settings','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','drupal_get_form',X'613A313A7B693A303B733A31393A22757365725F61646D696E5F73657474696E6773223B7D','',31,5,1,'admin/config/people/accounts','admin/config/people/accounts','Settings','t','','','a:0:{}',140,'','',-10,'modules/user/user.admin.inc'),
	('admin/config/people/ip-blocking','','','user_access',X'613A313A7B693A303B733A31383A22626C6F636B20495020616464726573736573223B7D','system_ip_blocking',X'613A303A7B7D','',15,4,0,'','admin/config/people/ip-blocking','IP address blocking','t','','','a:0:{}',6,'Manage blocked IP addresses.','',10,'modules/system/system.admin.inc'),
	('admin/config/people/ip-blocking/delete/%',X'613A313A7B693A353B733A31353A22626C6F636B65645F69705F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31383A22626C6F636B20495020616464726573736573223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A2273797374656D5F69705F626C6F636B696E675F64656C657465223B693A313B693A353B7D','',62,6,0,'','admin/config/people/ip-blocking/delete/%','Delete IP address','t','','','a:0:{}',6,'','',0,'modules/system/system.admin.inc'),
	('admin/config/regional','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/regional','Regional and language','t','','','a:0:{}',6,'Regional settings, localization and translation.','left',-5,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32353A2273797374656D5F646174655F74696D655F73657474696E6773223B7D','',15,4,0,'','admin/config/regional/date-time','Date and time','t','','','a:0:{}',6,'Configure display formats for date and time.','',-15,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/formats','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','system_date_time_formats',X'613A303A7B7D','',31,5,1,'admin/config/regional/date-time','admin/config/regional/date-time','Formats','t','','','a:0:{}',132,'Configure display format strings for date and time.','',-9,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/formats/%/delete',X'613A313A7B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A323A7B693A303B733A33303A2273797374656D5F646174655F64656C6574655F666F726D61745F666F726D223B693A313B693A353B7D','',125,7,0,'','admin/config/regional/date-time/formats/%/delete','Delete date format','t','','','a:0:{}',6,'Allow users to delete a configured date format.','',0,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/formats/%/edit',X'613A313A7B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A323A7B693A303B733A33343A2273797374656D5F636F6E6669677572655F646174655F666F726D6174735F666F726D223B693A313B693A353B7D','',125,7,0,'','admin/config/regional/date-time/formats/%/edit','Edit date format','t','','','a:0:{}',6,'Allow users to edit a configured date format.','',0,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/formats/add','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A33343A2273797374656D5F636F6E6669677572655F646174655F666F726D6174735F666F726D223B7D','',63,6,1,'admin/config/regional/date-time/formats','admin/config/regional/date-time','Add format','t','','','a:0:{}',388,'Allow users to add additional date formats.','',-10,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/formats/lookup','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','system_date_time_lookup',X'613A303A7B7D','',63,6,0,'','admin/config/regional/date-time/formats/lookup','Date and time lookup','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/types','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32353A2273797374656D5F646174655F74696D655F73657474696E6773223B7D','',31,5,1,'admin/config/regional/date-time','admin/config/regional/date-time','Types','t','','','a:0:{}',140,'Configure display formats for date and time.','',-10,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/types/%/delete',X'613A313A7B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A323A7B693A303B733A33353A2273797374656D5F64656C6574655F646174655F666F726D61745F747970655F666F726D223B693A313B693A353B7D','',125,7,0,'','admin/config/regional/date-time/types/%/delete','Delete date type','t','','','a:0:{}',6,'Allow users to delete a configured date type.','',0,'modules/system/system.admin.inc'),
	('admin/config/regional/date-time/types/add','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A33323A2273797374656D5F6164645F646174655F666F726D61745F747970655F666F726D223B7D','',63,6,1,'admin/config/regional/date-time/types','admin/config/regional/date-time','Add date type','t','','','a:0:{}',388,'Add new date type.','',-10,'modules/system/system.admin.inc'),
	('admin/config/regional/settings','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32343A2273797374656D5F726567696F6E616C5F73657474696E6773223B7D','',15,4,0,'','admin/config/regional/settings','Regional settings','t','','','a:0:{}',6,'Settings for the site\'s default time zone and country.','',-20,'modules/system/system.admin.inc'),
	('admin/config/search','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/search','Search and metadata','t','','','a:0:{}',6,'Local site search, metadata and SEO.','left',-10,'modules/system/system.admin.inc'),
	('admin/config/search/clean-urls','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32353A2273797374656D5F636C65616E5F75726C5F73657474696E6773223B7D','',15,4,0,'','admin/config/search/clean-urls','Clean URLs','t','','','a:0:{}',6,'Enable or disable clean URLs for your site.','',5,'modules/system/system.admin.inc'),
	('admin/config/search/clean-urls/check','','','1',X'613A303A7B7D','drupal_json_output',X'613A313A7B693A303B613A313A7B733A363A22737461747573223B623A313B7D7D','',31,5,0,'','admin/config/search/clean-urls/check','Clean URL check','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/config/search/path','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E69737465722075726C20616C6961736573223B7D','path_admin_overview',X'613A303A7B7D','',15,4,0,'','admin/config/search/path','URL aliases','t','','','a:0:{}',6,'Change your site\'s URL paths by aliasing them.','',-5,'modules/path/path.admin.inc'),
	('admin/config/search/path/add','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E69737465722075726C20616C6961736573223B7D','path_admin_edit',X'613A303A7B7D','',31,5,1,'admin/config/search/path','admin/config/search/path','Add alias','t','','','a:0:{}',388,'','',0,'modules/path/path.admin.inc'),
	('admin/config/search/path/delete/%',X'613A313A7B693A353B733A393A22706174685F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32323A2261646D696E69737465722075726C20616C6961736573223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A22706174685F61646D696E5F64656C6574655F636F6E6669726D223B693A313B693A353B7D','',62,6,0,'','admin/config/search/path/delete/%','Delete alias','t','','','a:0:{}',6,'','',0,'modules/path/path.admin.inc'),
	('admin/config/search/path/edit/%',X'613A313A7B693A353B733A393A22706174685F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32323A2261646D696E69737465722075726C20616C6961736573223B7D','path_admin_edit',X'613A313A7B693A303B693A353B7D','',62,6,0,'','admin/config/search/path/edit/%','Edit alias','t','','','a:0:{}',6,'','',0,'modules/path/path.admin.inc'),
	('admin/config/search/path/list','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E69737465722075726C20616C6961736573223B7D','path_admin_overview',X'613A303A7B7D','',31,5,1,'admin/config/search/path','admin/config/search/path','List','t','','','a:0:{}',140,'','',-10,'modules/path/path.admin.inc'),
	('admin/config/search/settings','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220736561726368223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A227365617263685F61646D696E5F73657474696E6773223B7D','',15,4,0,'','admin/config/search/settings','Search settings','t','','','a:0:{}',6,'Configure relevance settings for search and other indexing options.','',-10,'modules/search/search.admin.inc'),
	('admin/config/search/settings/reindex','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220736561726368223B7D','drupal_get_form',X'613A313A7B693A303B733A32323A227365617263685F7265696E6465785F636F6E6669726D223B7D','',31,5,0,'','admin/config/search/settings/reindex','Clear index','t','','','a:0:{}',4,'','',0,'modules/search/search.admin.inc'),
	('admin/config/services','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/services','Web services','t','','','a:0:{}',6,'Tools related to web services.','right',0,'modules/system/system.admin.inc'),
	('admin/config/services/rss-publishing','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32353A2273797374656D5F7273735F66656564735F73657474696E6773223B7D','',15,4,0,'','admin/config/services/rss-publishing','RSS publishing','t','','','a:0:{}',6,'Configure the site description, the number of items per feed and whether feeds should be titles/teasers/full-text.','',0,'modules/system/system.admin.inc'),
	('admin/config/system','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/system','System','t','','','a:0:{}',6,'General system related configuration.','right',-20,'modules/system/system.admin.inc'),
	('admin/config/system/actions','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E697374657220616374696F6E73223B7D','system_actions_manage',X'613A303A7B7D','',15,4,0,'','admin/config/system/actions','Actions','t','','','a:0:{}',6,'Manage the actions defined for your site.','',0,'modules/system/system.admin.inc'),
	('admin/config/system/actions/configure','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E697374657220616374696F6E73223B7D','drupal_get_form',X'613A313A7B693A303B733A32343A2273797374656D5F616374696F6E735F636F6E666967757265223B7D','',31,5,0,'','admin/config/system/actions/configure','Configure an advanced action','t','','','a:0:{}',4,'','',0,'modules/system/system.admin.inc'),
	('admin/config/system/actions/delete/%',X'613A313A7B693A353B733A31323A22616374696F6E735F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31383A2261646D696E697374657220616374696F6E73223B7D','drupal_get_form',X'613A323A7B693A303B733A32363A2273797374656D5F616374696F6E735F64656C6574655F666F726D223B693A313B693A353B7D','',62,6,0,'','admin/config/system/actions/delete/%','Delete action','t','','','a:0:{}',6,'Delete an action.','',0,'modules/system/system.admin.inc'),
	('admin/config/system/actions/manage','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E697374657220616374696F6E73223B7D','system_actions_manage',X'613A303A7B7D','',31,5,1,'admin/config/system/actions','admin/config/system/actions','Manage actions','t','','','a:0:{}',140,'Manage the actions defined for your site.','',-2,'modules/system/system.admin.inc'),
	('admin/config/system/actions/orphan','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E697374657220616374696F6E73223B7D','system_actions_remove_orphans',X'613A303A7B7D','',31,5,0,'','admin/config/system/actions/orphan','Remove orphans','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/config/system/cron','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A2273797374656D5F63726F6E5F73657474696E6773223B7D','',15,4,0,'','admin/config/system/cron','Cron','t','','','a:0:{}',6,'Manage automatic site maintenance tasks.','',20,'modules/system/system.admin.inc'),
	('admin/config/system/site-information','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','drupal_get_form',X'613A313A7B693A303B733A33323A2273797374656D5F736974655F696E666F726D6174696F6E5F73657474696E6773223B7D','',15,4,0,'','admin/config/system/site-information','Site information','t','','','a:0:{}',6,'Change site name, e-mail address, slogan, default front page, and number of posts per page, error pages.','',-20,'modules/system/system.admin.inc'),
	('admin/config/user-interface','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/user-interface','User interface','t','','','a:0:{}',6,'Tools that enhance the user interface.','right',-15,'modules/system/system.admin.inc'),
	('admin/config/user-interface/shortcut','','','user_access',X'613A313A7B693A303B733A32303A2261646D696E69737465722073686F727463757473223B7D','shortcut_set_admin',X'613A303A7B7D','',15,4,0,'','admin/config/user-interface/shortcut','Shortcuts','t','','','a:0:{}',6,'Add and modify shortcut sets.','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_edit_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A32323A2273686F72746375745F7365745F637573746F6D697A65223B693A313B693A343B7D','',30,5,0,'','admin/config/user-interface/shortcut/%','Edit shortcuts','shortcut_set_title_callback','a:1:{i:0;i:4;}','','a:0:{}',6,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%/add-link',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_edit_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A31373A2273686F72746375745F6C696E6B5F616464223B693A313B693A343B7D','',61,6,1,'admin/config/user-interface/shortcut/%','admin/config/user-interface/shortcut/%','Add shortcut','t','','','a:0:{}',388,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%/add-link-inline',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_edit_access',X'613A313A7B693A303B693A343B7D','shortcut_link_add_inline',X'613A313A7B693A303B693A343B7D','',61,6,0,'','admin/config/user-interface/shortcut/%/add-link-inline','Add shortcut','t','','','a:0:{}',0,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%/delete',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_delete_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A32343A2273686F72746375745F7365745F64656C6574655F666F726D223B693A313B693A343B7D','',61,6,0,'','admin/config/user-interface/shortcut/%/delete','Delete shortcut set','t','','','a:0:{}',6,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%/edit',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_edit_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A32323A2273686F72746375745F7365745F656469745F666F726D223B693A313B693A343B7D','',61,6,1,'admin/config/user-interface/shortcut/%','admin/config/user-interface/shortcut/%','Edit set name','t','','','a:0:{}',132,'','',10,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/%/links',X'613A313A7B693A343B733A31373A2273686F72746375745F7365745F6C6F6164223B7D','','shortcut_set_edit_access',X'613A313A7B693A303B693A343B7D','drupal_get_form',X'613A323A7B693A303B733A32323A2273686F72746375745F7365745F637573746F6D697A65223B693A313B693A343B7D','',61,6,1,'admin/config/user-interface/shortcut/%','admin/config/user-interface/shortcut/%','List links','t','','','a:0:{}',140,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/add-set','','','user_access',X'613A313A7B693A303B733A32303A2261646D696E69737465722073686F727463757473223B7D','drupal_get_form',X'613A313A7B693A303B733A32313A2273686F72746375745F7365745F6164645F666F726D223B7D','',31,5,1,'admin/config/user-interface/shortcut','admin/config/user-interface/shortcut','Add shortcut set','t','','','a:0:{}',388,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/link/%',X'613A313A7B693A353B733A31343A226D656E755F6C696E6B5F6C6F6164223B7D','','shortcut_link_access',X'613A313A7B693A303B693A353B7D','drupal_get_form',X'613A323A7B693A303B733A31383A2273686F72746375745F6C696E6B5F65646974223B693A313B693A353B7D','',62,6,0,'','admin/config/user-interface/shortcut/link/%','Edit shortcut','t','','','a:0:{}',6,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/user-interface/shortcut/link/%/delete',X'613A313A7B693A353B733A31343A226D656E755F6C696E6B5F6C6F6164223B7D','','shortcut_link_access',X'613A313A7B693A303B693A353B7D','drupal_get_form',X'613A323A7B693A303B733A32303A2273686F72746375745F6C696E6B5F64656C657465223B693A313B693A353B7D','',125,7,0,'','admin/config/user-interface/shortcut/link/%/delete','Delete shortcut','t','','','a:0:{}',6,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('admin/config/workflow','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',7,3,0,'','admin/config/workflow','Workflow','t','','','a:0:{}',6,'Content workflow, editorial workflow tools.','right',5,'modules/system/system.admin.inc'),
	('admin/content','','','user_access',X'613A313A7B693A303B733A32333A2261636365737320636F6E74656E74206F76657276696577223B7D','drupal_get_form',X'613A313A7B693A303B733A31383A226E6F64655F61646D696E5F636F6E74656E74223B7D','',3,2,0,'','admin/content','Content','t','','','a:0:{}',6,'Administer content and comments.','',-10,'modules/node/node.admin.inc'),
	('admin/content/comment','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E697374657220636F6D6D656E7473223B7D','comment_admin',X'613A303A7B7D','',7,3,1,'admin/content','admin/content','Comments','t','','','a:0:{}',134,'List and edit site comments and the comment approval queue.','',0,'modules/comment/comment.admin.inc'),
	('admin/content/comment/approval','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E697374657220636F6D6D656E7473223B7D','comment_admin',X'613A313A7B693A303B733A383A22617070726F76616C223B7D','',15,4,1,'admin/content/comment','admin/content','Unapproved comments','comment_count_unpublished','','','a:0:{}',132,'','',0,'modules/comment/comment.admin.inc'),
	('admin/content/comment/new','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E697374657220636F6D6D656E7473223B7D','comment_admin',X'613A303A7B7D','',15,4,1,'admin/content/comment','admin/content','Published comments','t','','','a:0:{}',140,'','',-10,'modules/comment/comment.admin.inc'),
	('admin/content/node','','','user_access',X'613A313A7B693A303B733A32333A2261636365737320636F6E74656E74206F76657276696577223B7D','drupal_get_form',X'613A313A7B693A303B733A31383A226E6F64655F61646D696E5F636F6E74656E74223B7D','',7,3,1,'admin/content','admin/content','Content','t','','','a:0:{}',140,'','',-10,'modules/node/node.admin.inc'),
	('admin/dashboard','','','user_access',X'613A313A7B693A303B733A31363A226163636573732064617368626F617264223B7D','dashboard_admin',X'613A303A7B7D','',3,2,0,'','admin/dashboard','Dashboard','t','','','a:0:{}',6,'View and customize your dashboard.','',-15,''),
	('admin/dashboard/block-content/%/%',X'613A323A7B693A333B4E3B693A343B4E3B7D','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','dashboard_show_block_content',X'613A323A7B693A303B693A333B693A313B693A343B7D','',28,5,0,'','admin/dashboard/block-content/%/%','','t','','','a:0:{}',0,'','',0,''),
	('admin/dashboard/configure','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','dashboard_admin_blocks',X'613A303A7B7D','',7,3,0,'','admin/dashboard/configure','Configure available dashboard blocks','t','','','a:0:{}',4,'Configure which blocks can be shown on the dashboard.','',0,''),
	('admin/dashboard/customize','','','user_access',X'613A313A7B693A303B733A31363A226163636573732064617368626F617264223B7D','dashboard_admin',X'613A313A7B693A303B623A313B7D','',7,3,0,'','admin/dashboard/customize','Customize dashboard','t','','','a:0:{}',4,'Customize your dashboard.','',0,''),
	('admin/dashboard/drawer','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','dashboard_show_disabled',X'613A303A7B7D','',7,3,0,'','admin/dashboard/drawer','','t','','','a:0:{}',0,'','',0,''),
	('admin/dashboard/update','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','dashboard_update',X'613A303A7B7D','',7,3,0,'','admin/dashboard/update','','t','','','a:0:{}',0,'','',0,''),
	('admin/help','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_main',X'613A303A7B7D','',3,2,0,'','admin/help','Help','t','','','a:0:{}',6,'Reference for usage, configuration, and modules.','',9,'modules/help/help.admin.inc'),
	('admin/help/block','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/block','block','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/color','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/color','color','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/comment','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/comment','comment','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/contextual','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/contextual','contextual','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/dashboard','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/dashboard','dashboard','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/dblog','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/dblog','dblog','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/field','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/field','field','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/field_sql_storage','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/field_sql_storage','field_sql_storage','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/field_ui','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/field_ui','field_ui','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/file','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/file','file','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/filter','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/filter','filter','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/help','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/help','help','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/image','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/image','image','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/list','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/list','list','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/menu','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/menu','menu','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/node','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/node','node','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/number','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/number','number','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/options','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/options','options','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/overlay','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/overlay','overlay','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/path','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/path','path','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/rdf','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/rdf','rdf','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/search','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/search','search','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/shortcut','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/shortcut','shortcut','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/system','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/system','system','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/taxonomy','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/taxonomy','taxonomy','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/text','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/text','text','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/toolbar','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/toolbar','toolbar','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/help/user','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','help_page',X'613A313A7B693A303B693A323B7D','',7,3,0,'','admin/help/user','user','t','','','a:0:{}',4,'','',0,'modules/help/help.admin.inc'),
	('admin/index','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_index',X'613A303A7B7D','',3,2,1,'admin','admin','Index','t','','','a:0:{}',132,'','',-18,'modules/system/system.admin.inc'),
	('admin/modules','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E6973746572206D6F64756C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A31343A2273797374656D5F6D6F64756C6573223B7D','',3,2,0,'','admin/modules','Modules','t','','','a:0:{}',6,'Extend site functionality.','',-2,'modules/system/system.admin.inc'),
	('admin/modules/list','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E6973746572206D6F64756C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A31343A2273797374656D5F6D6F64756C6573223B7D','',7,3,1,'admin/modules','admin/modules','List','t','','','a:0:{}',140,'','',0,'modules/system/system.admin.inc'),
	('admin/modules/list/confirm','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E6973746572206D6F64756C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A31343A2273797374656D5F6D6F64756C6573223B7D','',15,4,0,'','admin/modules/list/confirm','List','t','','','a:0:{}',4,'','',0,'modules/system/system.admin.inc'),
	('admin/modules/uninstall','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E6973746572206D6F64756C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A32343A2273797374656D5F6D6F64756C65735F756E696E7374616C6C223B7D','',7,3,1,'admin/modules','admin/modules','Uninstall','t','','','a:0:{}',132,'','',20,'modules/system/system.admin.inc'),
	('admin/modules/uninstall/confirm','','','user_access',X'613A313A7B693A303B733A31383A2261646D696E6973746572206D6F64756C6573223B7D','drupal_get_form',X'613A313A7B693A303B733A32343A2273797374656D5F6D6F64756C65735F756E696E7374616C6C223B7D','',15,4,0,'','admin/modules/uninstall/confirm','Uninstall','t','','','a:0:{}',4,'','',0,'modules/system/system.admin.inc'),
	('admin/people','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','user_admin',X'613A313A7B693A303B733A343A226C697374223B7D','',3,2,0,'','admin/people','People','t','','','a:0:{}',6,'Manage user accounts, roles, and permissions.','left',-4,'modules/user/user.admin.inc'),
	('admin/people/create','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','user_admin',X'613A313A7B693A303B733A363A22637265617465223B7D','',7,3,1,'admin/people','admin/people','Add user','t','','','a:0:{}',388,'','',0,'modules/user/user.admin.inc'),
	('admin/people/people','','','user_access',X'613A313A7B693A303B733A31363A2261646D696E6973746572207573657273223B7D','user_admin',X'613A313A7B693A303B733A343A226C697374223B7D','',7,3,1,'admin/people','admin/people','List','t','','','a:0:{}',140,'Find and manage people interacting with your site.','',-10,'modules/user/user.admin.inc'),
	('admin/people/permissions','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E6973746572207065726D697373696F6E73223B7D','drupal_get_form',X'613A313A7B693A303B733A32323A22757365725F61646D696E5F7065726D697373696F6E73223B7D','',7,3,1,'admin/people','admin/people','Permissions','t','','','a:0:{}',132,'Determine access to features by selecting permissions for roles.','',0,'modules/user/user.admin.inc'),
	('admin/people/permissions/list','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E6973746572207065726D697373696F6E73223B7D','drupal_get_form',X'613A313A7B693A303B733A32323A22757365725F61646D696E5F7065726D697373696F6E73223B7D','',15,4,1,'admin/people/permissions','admin/people','Permissions','t','','','a:0:{}',140,'Determine access to features by selecting permissions for roles.','',-8,'modules/user/user.admin.inc'),
	('admin/people/permissions/roles','','','user_access',X'613A313A7B693A303B733A32323A2261646D696E6973746572207065726D697373696F6E73223B7D','drupal_get_form',X'613A313A7B693A303B733A31363A22757365725F61646D696E5F726F6C6573223B7D','',15,4,1,'admin/people/permissions','admin/people','Roles','t','','','a:0:{}',132,'List, edit, or add user roles.','',-5,'modules/user/user.admin.inc'),
	('admin/people/permissions/roles/delete/%',X'613A313A7B693A353B733A31343A22757365725F726F6C655F6C6F6164223B7D','','user_role_edit_access',X'613A313A7B693A303B693A353B7D','drupal_get_form',X'613A323A7B693A303B733A33303A22757365725F61646D696E5F726F6C655F64656C6574655F636F6E6669726D223B693A313B693A353B7D','',62,6,0,'','admin/people/permissions/roles/delete/%','Delete role','t','','','a:0:{}',6,'','',0,'modules/user/user.admin.inc'),
	('admin/people/permissions/roles/edit/%',X'613A313A7B693A353B733A31343A22757365725F726F6C655F6C6F6164223B7D','','user_role_edit_access',X'613A313A7B693A303B693A353B7D','drupal_get_form',X'613A323A7B693A303B733A31353A22757365725F61646D696E5F726F6C65223B693A313B693A353B7D','',62,6,0,'','admin/people/permissions/roles/edit/%','Edit role','t','','','a:0:{}',6,'','',0,'modules/user/user.admin.inc'),
	('admin/reports','','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','system_admin_menu_block_page',X'613A303A7B7D','',3,2,0,'','admin/reports','Reports','t','','','a:0:{}',6,'View reports, updates, and errors.','left',5,'modules/system/system.admin.inc'),
	('admin/reports/access-denied','','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','dblog_top',X'613A313A7B693A303B733A31333A226163636573732064656E696564223B7D','',7,3,0,'','admin/reports/access-denied','Top \'access denied\' errors','t','','','a:0:{}',6,'View \'access denied\' errors (403s).','',0,'modules/dblog/dblog.admin.inc'),
	('admin/reports/dblog','','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','dblog_overview',X'613A303A7B7D','',7,3,0,'','admin/reports/dblog','Recent log messages','t','','','a:0:{}',6,'View events that have recently been logged.','',-1,'modules/dblog/dblog.admin.inc'),
	('admin/reports/event/%',X'613A313A7B693A333B4E3B7D','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','dblog_event',X'613A313A7B693A303B693A333B7D','',14,4,0,'','admin/reports/event/%','Details','t','','','a:0:{}',6,'','',0,'modules/dblog/dblog.admin.inc'),
	('admin/reports/fields','','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','field_ui_fields_list',X'613A303A7B7D','',7,3,0,'','admin/reports/fields','Field list','t','','','a:0:{}',6,'Overview of fields on all entity types.','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/reports/page-not-found','','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','dblog_top',X'613A313A7B693A303B733A31343A2270616765206E6F7420666F756E64223B7D','',7,3,0,'','admin/reports/page-not-found','Top \'page not found\' errors','t','','','a:0:{}',6,'View \'page not found\' errors (404s).','',0,'modules/dblog/dblog.admin.inc'),
	('admin/reports/search','','','user_access',X'613A313A7B693A303B733A31393A226163636573732073697465207265706F727473223B7D','dblog_top',X'613A313A7B693A303B733A363A22736561726368223B7D','',7,3,0,'','admin/reports/search','Top search phrases','t','','','a:0:{}',6,'View most popular search phrases.','',0,'modules/dblog/dblog.admin.inc'),
	('admin/reports/status','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','system_status',X'613A303A7B7D','',7,3,0,'','admin/reports/status','Status report','t','','','a:0:{}',6,'Get a status report about your site\'s operation and any detected problems.','',-60,'modules/system/system.admin.inc'),
	('admin/reports/status/php','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','system_php',X'613A303A7B7D','',15,4,0,'','admin/reports/status/php','PHP','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/reports/status/rebuild','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','drupal_get_form',X'613A313A7B693A303B733A33303A226E6F64655F636F6E6669677572655F72656275696C645F636F6E6669726D223B7D','',15,4,0,'','admin/reports/status/rebuild','Rebuild permissions','t','','','a:0:{}',0,'','',0,'modules/node/node.admin.inc'),
	('admin/reports/status/run-cron','','','user_access',X'613A313A7B693A303B733A32393A2261646D696E6973746572207369746520636F6E66696775726174696F6E223B7D','system_run_cron',X'613A303A7B7D','',15,4,0,'','admin/reports/status/run-cron','Run cron','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('admin/structure','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',3,2,0,'','admin/structure','Structure','t','','','a:0:{}',6,'Administer blocks, content types, menus, etc.','right',-8,'modules/system/system.admin.inc'),
	('admin/structure/block','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','block_admin_display',X'613A313A7B693A303B733A363A2262617274696B223B7D','',7,3,0,'','admin/structure/block','Blocks','t','','','a:0:{}',6,'Configure what block content appears in your site\'s sidebars and other regions.','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/add','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A22626C6F636B5F6164645F626C6F636B5F666F726D223B7D','',15,4,1,'admin/structure/block','admin/structure/block','Add block','t','','','a:0:{}',388,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/demo/bartik','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32353A227468656D65732F62617274696B2F62617274696B2E696E666F223B733A343A226E616D65223B733A363A2262617274696B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A363A2242617274696B223B733A31313A226465736372697074696F6E223B733A34383A224120666C657869626C652C207265636F6C6F7261626C65207468656D652077697468206D616E7920726567696F6E732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A373A22726567696F6E73223B613A32303A7B733A363A22686561646572223B733A363A22486561646572223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A383A226665617475726564223B733A383A224665617475726564223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A31333A22736964656261725F6669727374223B733A31333A2253696465626172206669727374223B733A31343A22736964656261725F7365636F6E64223B733A31343A2253696465626172207365636F6E64223B733A31343A2274726970747963685F6669727374223B733A31343A225472697074796368206669727374223B733A31353A2274726970747963685F6D6964646C65223B733A31353A225472697074796368206D6964646C65223B733A31333A2274726970747963685F6C617374223B733A31333A225472697074796368206C617374223B733A31383A22666F6F7465725F6669727374636F6C756D6E223B733A31393A22466F6F74657220666972737420636F6C756D6E223B733A31393A22666F6F7465725F7365636F6E64636F6C756D6E223B733A32303A22466F6F746572207365636F6E6420636F6C756D6E223B733A31383A22666F6F7465725F7468697264636F6C756D6E223B733A31393A22466F6F74657220746869726420636F6C756D6E223B733A31393A22666F6F7465725F666F75727468636F6C756D6E223B733A32303A22466F6F74657220666F7572746820636F6C756D6E223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2230223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32383A227468656D65732F62617274696B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_demo',X'613A313A7B693A303B733A363A2262617274696B223B7D','',31,5,0,'','admin/structure/block/demo/bartik','Bartik','t','','_block_custom_theme','a:1:{i:0;s:6:\"bartik\";}',0,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/demo/garland','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32373A227468656D65732F6761726C616E642F6761726C616E642E696E666F223B733A343A226E616D65223B733A373A226761726C616E64223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A373A224761726C616E64223B733A31313A226465736372697074696F6E223B733A3131313A2241206D756C74692D636F6C756D6E207468656D652077686963682063616E20626520636F6E6669677572656420746F206D6F6469667920636F6C6F727320616E6420737769746368206265747765656E20666978656420616E6420666C756964207769647468206C61796F7574732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A31333A226761726C616E645F7769647468223B733A353A22666C756964223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32393A227468656D65732F6761726C616E642F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_demo',X'613A313A7B693A303B733A373A226761726C616E64223B7D','',31,5,0,'','admin/structure/block/demo/garland','Garland','t','','_block_custom_theme','a:1:{i:0;s:7:\"garland\";}',0,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/demo/seven','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F736576656E2F736576656E2E696E666F223B733A343A226E616D65223B733A353A22736576656E223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A353A22536576656E223B733A31313A226465736372697074696F6E223B733A36353A22412073696D706C65206F6E652D636F6C756D6E2C207461626C656C6573732C20666C7569642077696474682061646D696E697374726174696F6E207468656D652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2231223B7D733A373A22726567696F6E73223B613A383A7B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31333A22736964656261725F6669727374223B733A31333A2246697273742073696465626172223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A31343A22726567696F6E735F68696464656E223B613A333A7B693A303B733A31333A22736964656261725F6669727374223B693A313B733A383A22706167655F746F70223B693A323B733A31313A22706167655F626F74746F6D223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F736576656E2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_demo',X'613A313A7B693A303B733A353A22736576656E223B7D','',31,5,0,'','admin/structure/block/demo/seven','Seven','t','','_block_custom_theme','a:1:{i:0;s:5:\"seven\";}',0,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/demo/stark','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F737461726B2F737461726B2E696E666F223B733A343A226E616D65223B733A353A22737461726B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31383A7B733A343A226E616D65223B733A353A22537461726B223B733A31313A226465736372697074696F6E223B733A3230383A2254686973207468656D652064656D6F6E737472617465732044727570616C27732064656661756C742048544D4C206D61726B757020616E6420435353207374796C65732E20546F206C6561726E20686F7720746F206275696C6420796F7572206F776E207468656D6520616E64206F766572726964652044727570616C27732064656661756C7420636F64652C2073656520746865203C6120687265663D22687474703A2F2F64727570616C2E6F72672F7468656D652D6775696465223E5468656D696E672047756964653C2F613E2E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F737461726B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_demo',X'613A313A7B693A303B733A353A22737461726B223B7D','',31,5,0,'','admin/structure/block/demo/stark','Stark','t','','_block_custom_theme','a:1:{i:0;s:5:\"stark\";}',0,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/bartik','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32353A227468656D65732F62617274696B2F62617274696B2E696E666F223B733A343A226E616D65223B733A363A2262617274696B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A363A2242617274696B223B733A31313A226465736372697074696F6E223B733A34383A224120666C657869626C652C207265636F6C6F7261626C65207468656D652077697468206D616E7920726567696F6E732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A373A22726567696F6E73223B613A32303A7B733A363A22686561646572223B733A363A22486561646572223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A383A226665617475726564223B733A383A224665617475726564223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A31333A22736964656261725F6669727374223B733A31333A2253696465626172206669727374223B733A31343A22736964656261725F7365636F6E64223B733A31343A2253696465626172207365636F6E64223B733A31343A2274726970747963685F6669727374223B733A31343A225472697074796368206669727374223B733A31353A2274726970747963685F6D6964646C65223B733A31353A225472697074796368206D6964646C65223B733A31333A2274726970747963685F6C617374223B733A31333A225472697074796368206C617374223B733A31383A22666F6F7465725F6669727374636F6C756D6E223B733A31393A22466F6F74657220666972737420636F6C756D6E223B733A31393A22666F6F7465725F7365636F6E64636F6C756D6E223B733A32303A22466F6F746572207365636F6E6420636F6C756D6E223B733A31383A22666F6F7465725F7468697264636F6C756D6E223B733A31393A22466F6F74657220746869726420636F6C756D6E223B733A31393A22666F6F7465725F666F75727468636F6C756D6E223B733A32303A22466F6F74657220666F7572746820636F6C756D6E223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2230223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32383A227468656D65732F62617274696B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_display',X'613A313A7B693A303B733A363A2262617274696B223B7D','',31,5,1,'admin/structure/block','admin/structure/block','Bartik','t','','','a:0:{}',140,'','',-10,'modules/block/block.admin.inc'),
	('admin/structure/block/list/garland','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32373A227468656D65732F6761726C616E642F6761726C616E642E696E666F223B733A343A226E616D65223B733A373A226761726C616E64223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A373A224761726C616E64223B733A31313A226465736372697074696F6E223B733A3131313A2241206D756C74692D636F6C756D6E207468656D652077686963682063616E20626520636F6E6669677572656420746F206D6F6469667920636F6C6F727320616E6420737769746368206265747765656E20666978656420616E6420666C756964207769647468206C61796F7574732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A31333A226761726C616E645F7769647468223B733A353A22666C756964223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32393A227468656D65732F6761726C616E642F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_display',X'613A313A7B693A303B733A373A226761726C616E64223B7D','',31,5,1,'admin/structure/block','admin/structure/block','Garland','t','','','a:0:{}',132,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/garland/add','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A22626C6F636B5F6164645F626C6F636B5F666F726D223B7D','',63,6,1,'admin/structure/block/list/garland','admin/structure/block','Add block','t','','','a:0:{}',388,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/seven','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F736576656E2F736576656E2E696E666F223B733A343A226E616D65223B733A353A22736576656E223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2231223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31393A7B733A343A226E616D65223B733A353A22536576656E223B733A31313A226465736372697074696F6E223B733A36353A22412073696D706C65206F6E652D636F6C756D6E2C207461626C656C6573732C20666C7569642077696474682061646D696E697374726174696F6E207468656D652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2231223B7D733A373A22726567696F6E73223B613A383A7B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31333A22736964656261725F6669727374223B733A31333A2246697273742073696465626172223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A31343A22726567696F6E735F68696464656E223B613A333A7B693A303B733A31333A22736964656261725F6669727374223B693A313B733A383A22706167655F746F70223B693A323B733A31313A22706167655F626F74746F6D223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F736576656E2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_display',X'613A313A7B693A303B733A353A22736576656E223B7D','',31,5,1,'admin/structure/block','admin/structure/block','Seven','t','','','a:0:{}',132,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/seven/add','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A22626C6F636B5F6164645F626C6F636B5F666F726D223B7D','',63,6,1,'admin/structure/block/list/seven','admin/structure/block','Add block','t','','','a:0:{}',388,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/stark','','','_block_themes_access',X'613A313A7B693A303B4F3A383A22737464436C617373223A31323A7B733A383A2266696C656E616D65223B733A32333A227468656D65732F737461726B2F737461726B2E696E666F223B733A343A226E616D65223B733A353A22737461726B223B733A343A2274797065223B733A353A227468656D65223B733A353A226F776E6572223B733A34353A227468656D65732F656E67696E65732F70687074656D706C6174652F70687074656D706C6174652E656E67696E65223B733A363A22737461747573223B733A313A2230223B733A393A22626F6F747374726170223B733A313A2230223B733A31343A22736368656D615F76657273696F6E223B733A323A222D31223B733A363A22776569676874223B733A313A2230223B733A343A22696E666F223B613A31383A7B733A343A226E616D65223B733A353A22537461726B223B733A31313A226465736372697074696F6E223B733A3230383A2254686973207468656D652064656D6F6E737472617465732044727570616C27732064656661756C742048544D4C206D61726B757020616E6420435353207374796C65732E20546F206C6561726E20686F7720746F206275696C6420796F7572206F776E207468656D6520616E64206F766572726964652044727570616C27732064656661756C7420636F64652C2073656520746865203C6120687265663D22687474703A2F2F64727570616C2E6F72672F7468656D652D6775696465223E5468656D696E672047756964653C2F613E2E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F737461726B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D733A363A22707265666978223B733A31313A2270687074656D706C617465223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B7D7D','block_admin_display',X'613A313A7B693A303B733A353A22737461726B223B7D','',31,5,1,'admin/structure/block','admin/structure/block','Stark','t','','','a:0:{}',132,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/list/stark/add','','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A313A7B693A303B733A32303A22626C6F636B5F6164645F626C6F636B5F666F726D223B7D','',63,6,1,'admin/structure/block/list/stark','admin/structure/block','Add block','t','','','a:0:{}',388,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/manage/%/%',X'613A323A7B693A343B4E3B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A333A7B693A303B733A32313A22626C6F636B5F61646D696E5F636F6E666967757265223B693A313B693A343B693A323B693A353B7D','',60,6,0,'','admin/structure/block/manage/%/%','Configure block','t','','','a:0:{}',6,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/manage/%/%/configure',X'613A323A7B693A343B4E3B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A333A7B693A303B733A32313A22626C6F636B5F61646D696E5F636F6E666967757265223B693A313B693A343B693A323B693A353B7D','',121,7,2,'admin/structure/block/manage/%/%','admin/structure/block/manage/%/%','Configure block','t','','','a:0:{}',140,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/block/manage/%/%/delete',X'613A323A7B693A343B4E3B693A353B4E3B7D','','user_access',X'613A313A7B693A303B733A31373A2261646D696E697374657220626C6F636B73223B7D','drupal_get_form',X'613A333A7B693A303B733A32353A22626C6F636B5F637573746F6D5F626C6F636B5F64656C657465223B693A313B693A343B693A323B693A353B7D','',121,7,0,'admin/structure/block/manage/%/%','admin/structure/block/manage/%/%','Delete block','t','','','a:0:{}',132,'','',0,'modules/block/block.admin.inc'),
	('admin/structure/menu','','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','menu_overview_page',X'613A303A7B7D','',7,3,0,'','admin/structure/menu','Menus','t','','','a:0:{}',6,'Add new menus to your site, edit existing menus, and rename and reorganize menu links.','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/add','','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A323A7B693A303B733A31343A226D656E755F656469745F6D656E75223B693A313B733A333A22616464223B7D','',15,4,1,'admin/structure/menu','admin/structure/menu','Add menu','t','','','a:0:{}',388,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/item/%/delete',X'613A313A7B693A343B733A31343A226D656E755F6C696E6B5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','menu_item_delete_page',X'613A313A7B693A303B693A343B7D','',61,6,0,'','admin/structure/menu/item/%/delete','Delete menu link','t','','','a:0:{}',6,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/item/%/edit',X'613A313A7B693A343B733A31343A226D656E755F6C696E6B5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A343A7B693A303B733A31343A226D656E755F656469745F6974656D223B693A313B733A343A2265646974223B693A323B693A343B693A333B4E3B7D','',61,6,0,'','admin/structure/menu/item/%/edit','Edit menu link','t','','','a:0:{}',6,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/item/%/reset',X'613A313A7B693A343B733A31343A226D656E755F6C696E6B5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A323A7B693A303B733A32333A226D656E755F72657365745F6974656D5F636F6E6669726D223B693A313B693A343B7D','',61,6,0,'','admin/structure/menu/item/%/reset','Reset menu link','t','','','a:0:{}',6,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/list','','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','menu_overview_page',X'613A303A7B7D','',15,4,1,'admin/structure/menu','admin/structure/menu','List menus','t','','','a:0:{}',140,'','',-10,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/manage/%',X'613A313A7B693A343B733A393A226D656E755F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A323A7B693A303B733A31383A226D656E755F6F766572766965775F666F726D223B693A313B693A343B7D','',30,5,0,'','admin/structure/menu/manage/%','Customize menu','menu_overview_title','a:1:{i:0;i:4;}','','a:0:{}',6,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/manage/%/add',X'613A313A7B693A343B733A393A226D656E755F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A343A7B693A303B733A31343A226D656E755F656469745F6974656D223B693A313B733A333A22616464223B693A323B4E3B693A333B693A343B7D','',61,6,1,'admin/structure/menu/manage/%','admin/structure/menu/manage/%','Add link','t','','','a:0:{}',388,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/manage/%/delete',X'613A313A7B693A343B733A393A226D656E755F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','menu_delete_menu_page',X'613A313A7B693A303B693A343B7D','',61,6,0,'','admin/structure/menu/manage/%/delete','Delete menu','t','','','a:0:{}',6,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/manage/%/edit',X'613A313A7B693A343B733A393A226D656E755F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A333A7B693A303B733A31343A226D656E755F656469745F6D656E75223B693A313B733A343A2265646974223B693A323B693A343B7D','',61,6,3,'admin/structure/menu/manage/%','admin/structure/menu/manage/%','Edit menu','t','','','a:0:{}',132,'','',0,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/manage/%/list',X'613A313A7B693A343B733A393A226D656E755F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A323A7B693A303B733A31383A226D656E755F6F766572766965775F666F726D223B693A313B693A343B7D','',61,6,3,'admin/structure/menu/manage/%','admin/structure/menu/manage/%','List links','t','','','a:0:{}',140,'','',-10,'modules/menu/menu.admin.inc'),
	('admin/structure/menu/parents','','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','menu_parent_options_js',X'613A303A7B7D','',15,4,0,'','admin/structure/menu/parents','Parent menu items','t','','','a:0:{}',0,'','',0,''),
	('admin/structure/menu/settings','','','user_access',X'613A313A7B693A303B733A31353A2261646D696E6973746572206D656E75223B7D','drupal_get_form',X'613A313A7B693A303B733A31343A226D656E755F636F6E666967757265223B7D','',15,4,1,'admin/structure/menu','admin/structure/menu','Settings','t','','','a:0:{}',132,'','',5,'modules/menu/menu.admin.inc'),
	('admin/structure/taxonomy','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A313A7B693A303B733A33303A227461786F6E6F6D795F6F766572766965775F766F636162756C6172696573223B7D','',7,3,0,'','admin/structure/taxonomy','Taxonomy','t','','','a:0:{}',6,'Manage tagging, categorization, and classification of your content.','',0,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/%',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32333A227461786F6E6F6D795F6F766572766965775F7465726D73223B693A313B693A333B7D','',14,4,0,'','admin/structure/taxonomy/%','','entity_label','a:2:{i:0;s:19:\"taxonomy_vocabulary\";i:1;i:3;}','','a:0:{}',6,'','',0,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/%/add',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A333A7B693A303B733A31383A227461786F6E6F6D795F666F726D5F7465726D223B693A313B613A303A7B7D693A323B693A333B7D','',29,5,1,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','Add term','t','','','a:0:{}',388,'','',0,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/%/display',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A31333A227461786F6E6F6D795F7465726D223B693A323B693A333B693A333B733A373A2264656661756C74223B7D','',29,5,1,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','Manage display','t','','','a:0:{}',132,'','',2,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/display/default',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A373A2264656661756C74223B693A333B733A31313A22757365725F616363657373223B693A343B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A31333A227461786F6E6F6D795F7465726D223B693A323B693A333B693A333B733A373A2264656661756C74223B7D','',59,6,1,'admin/structure/taxonomy/%/display','admin/structure/taxonomy/%','Default','t','','','a:0:{}',140,'','',-10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/display/full',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A343A2266756C6C223B693A333B733A31313A22757365725F616363657373223B693A343B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A31333A227461786F6E6F6D795F7465726D223B693A323B693A333B693A333B733A343A2266756C6C223B7D','',59,6,1,'admin/structure/taxonomy/%/display','admin/structure/taxonomy/%','Taxonomy term page','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/edit',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A227461786F6E6F6D795F666F726D5F766F636162756C617279223B693A313B693A333B7D','',29,5,1,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','Edit','t','','','a:0:{}',132,'','',-10,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/%/fields',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A333A7B693A303B733A32383A226669656C645F75695F6669656C645F6F766572766965775F666F726D223B693A313B733A31333A227461786F6E6F6D795F7465726D223B693A323B693A333B7D','',29,5,1,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','Manage fields','t','','','a:0:{}',132,'','',1,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/fields/%',X'613A323A7B693A333B613A313A7B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A353B7D','',58,6,0,'','admin/structure/taxonomy/%/fields/%','','field_ui_menu_title','a:1:{i:0;i:5;}','','a:0:{}',6,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/fields/%/delete',X'613A323A7B693A333B613A313A7B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32363A226669656C645F75695F6669656C645F64656C6574655F666F726D223B693A313B693A353B7D','',117,7,1,'admin/structure/taxonomy/%/fields/%','admin/structure/taxonomy/%/fields/%','Delete','t','','','a:0:{}',132,'','',10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/fields/%/edit',X'613A323A7B693A333B613A313A7B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A353B7D','',117,7,1,'admin/structure/taxonomy/%/fields/%','admin/structure/taxonomy/%/fields/%','Edit','t','','','a:0:{}',140,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/fields/%/field-settings',X'613A323A7B693A333B613A313A7B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226669656C645F75695F6669656C645F73657474696E67735F666F726D223B693A313B693A353B7D','',117,7,1,'admin/structure/taxonomy/%/fields/%','admin/structure/taxonomy/%/fields/%','Field settings','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/fields/%/widget-type',X'613A323A7B693A333B613A313A7B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D693A353B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A31333A227461786F6E6F6D795F7465726D223B693A313B693A333B693A323B733A313A2233223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A226669656C645F75695F7769646765745F747970655F666F726D223B693A313B693A353B7D','',117,7,1,'admin/structure/taxonomy/%/fields/%','admin/structure/taxonomy/%/fields/%','Widget type','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/taxonomy/%/list',X'613A313A7B693A333B733A33373A227461786F6E6F6D795F766F636162756C6172795F6D616368696E655F6E616D655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A323A7B693A303B733A32333A227461786F6E6F6D795F6F766572766965775F7465726D73223B693A313B693A333B7D','',29,5,1,'admin/structure/taxonomy/%','admin/structure/taxonomy/%','List','t','','','a:0:{}',140,'','',-20,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/add','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A313A7B693A303B733A32343A227461786F6E6F6D795F666F726D5F766F636162756C617279223B7D','',15,4,1,'admin/structure/taxonomy','admin/structure/taxonomy','Add vocabulary','t','','','a:0:{}',388,'','',0,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/taxonomy/list','','','user_access',X'613A313A7B693A303B733A31393A2261646D696E6973746572207461786F6E6F6D79223B7D','drupal_get_form',X'613A313A7B693A303B733A33303A227461786F6E6F6D795F6F766572766965775F766F636162756C6172696573223B7D','',15,4,1,'admin/structure/taxonomy','admin/structure/taxonomy','List','t','','','a:0:{}',140,'','',-10,'modules/taxonomy/taxonomy.admin.inc'),
	('admin/structure/types','','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','node_overview_types',X'613A303A7B7D','',7,3,0,'','admin/structure/types','Content types','t','','','a:0:{}',6,'Manage content types, including default status, front page promotion, comment settings, etc.','',0,'modules/node/content_types.inc'),
	('admin/structure/types/add','','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A313A7B693A303B733A31343A226E6F64655F747970655F666F726D223B7D','',15,4,1,'admin/structure/types','admin/structure/types','Add content type','t','','','a:0:{}',388,'','',0,'modules/node/content_types.inc'),
	('admin/structure/types/list','','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','node_overview_types',X'613A303A7B7D','',15,4,1,'admin/structure/types','admin/structure/types','List','t','','','a:0:{}',140,'','',-10,'modules/node/content_types.inc'),
	('admin/structure/types/manage/%',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A31343A226E6F64655F747970655F666F726D223B693A313B693A343B7D','',30,5,0,'','admin/structure/types/manage/%','Edit content type','node_type_page_title','a:1:{i:0;i:4;}','','a:0:{}',6,'','',0,'modules/node/content_types.inc'),
	('admin/structure/types/manage/%/comment/display',X'613A313A7B693A343B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A373A22636F6D6D656E74223B693A323B693A343B693A333B733A373A2264656661756C74223B7D','',123,7,1,'admin/structure/types/manage/%','admin/structure/types/manage/%','Comment display','t','','','a:0:{}',132,'','',4,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/display/default',X'613A313A7B693A343B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A373A2264656661756C74223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A373A22636F6D6D656E74223B693A323B693A343B693A333B733A373A2264656661756C74223B7D','',247,8,1,'admin/structure/types/manage/%/comment/display','admin/structure/types/manage/%','Default','t','','','a:0:{}',140,'','',-10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/display/full',X'613A313A7B693A343B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A343A2266756C6C223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A373A22636F6D6D656E74223B693A323B693A343B693A333B733A343A2266756C6C223B7D','',247,8,1,'admin/structure/types/manage/%/comment/display','admin/structure/types/manage/%','Full comment','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields',X'613A313A7B693A343B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A333A7B693A303B733A32383A226669656C645F75695F6669656C645F6F766572766965775F666F726D223B693A313B733A373A22636F6D6D656E74223B693A323B693A343B7D','',123,7,1,'admin/structure/types/manage/%','admin/structure/types/manage/%','Comment fields','t','','','a:0:{}',132,'','',3,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields/%',X'613A323A7B693A343B613A313A7B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A373B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A373B7D','',246,8,0,'','admin/structure/types/manage/%/comment/fields/%','','field_ui_menu_title','a:1:{i:0;i:7;}','','a:0:{}',6,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields/%/delete',X'613A323A7B693A343B613A313A7B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A373B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32363A226669656C645F75695F6669656C645F64656C6574655F666F726D223B693A313B693A373B7D','',493,9,1,'admin/structure/types/manage/%/comment/fields/%','admin/structure/types/manage/%/comment/fields/%','Delete','t','','','a:0:{}',132,'','',10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields/%/edit',X'613A323A7B693A343B613A313A7B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A373B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A373B7D','',493,9,1,'admin/structure/types/manage/%/comment/fields/%','admin/structure/types/manage/%/comment/fields/%','Edit','t','','','a:0:{}',140,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields/%/field-settings',X'613A323A7B693A343B613A313A7B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A373B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226669656C645F75695F6669656C645F73657474696E67735F666F726D223B693A313B693A373B7D','',493,9,1,'admin/structure/types/manage/%/comment/fields/%','admin/structure/types/manage/%/comment/fields/%','Field settings','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/comment/fields/%/widget-type',X'613A323A7B693A343B613A313A7B733A32323A22636F6D6D656E745F6E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A373B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A373A22636F6D6D656E74223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A226669656C645F75695F7769646765745F747970655F666F726D223B693A313B693A373B7D','',493,9,1,'admin/structure/types/manage/%/comment/fields/%','admin/structure/types/manage/%/comment/fields/%','Widget type','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/delete',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226E6F64655F747970655F64656C6574655F636F6E6669726D223B693A313B693A343B7D','',61,6,0,'','admin/structure/types/manage/%/delete','Delete','t','','','a:0:{}',6,'','',0,'modules/node/content_types.inc'),
	('admin/structure/types/manage/%/display',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A373A2264656661756C74223B7D','',61,6,1,'admin/structure/types/manage/%','admin/structure/types/manage/%','Manage display','t','','','a:0:{}',132,'','',2,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/default',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A373A2264656661756C74223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A373A2264656661756C74223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','Default','t','','','a:0:{}',140,'','',-10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/full',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A343A2266756C6C223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A343A2266756C6C223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','Full content','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/rss',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A333A22727373223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A333A22727373223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','RSS','t','','','a:0:{}',132,'','',2,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/search_index',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A31323A227365617263685F696E646578223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A31323A227365617263685F696E646578223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','Search index','t','','','a:0:{}',132,'','',3,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/search_result',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A31333A227365617263685F726573756C74223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A31333A227365617263685F726573756C74223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','Search result highlighting input','t','','','a:0:{}',132,'','',4,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/display/teaser',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','_field_ui_view_mode_menu_access',X'613A353A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A363A22746561736572223B693A333B733A31313A22757365725F616363657373223B693A343B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A343A7B693A303B733A33303A226669656C645F75695F646973706C61795F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B693A333B733A363A22746561736572223B7D','',123,7,1,'admin/structure/types/manage/%/display','admin/structure/types/manage/%','Teaser','t','','','a:0:{}',132,'','',1,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/edit',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A31343A226E6F64655F747970655F666F726D223B693A313B693A343B7D','',61,6,1,'admin/structure/types/manage/%','admin/structure/types/manage/%','Edit','t','','','a:0:{}',140,'','',0,'modules/node/content_types.inc'),
	('admin/structure/types/manage/%/fields',X'613A313A7B693A343B733A31343A226E6F64655F747970655F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A333A7B693A303B733A32383A226669656C645F75695F6669656C645F6F766572766965775F666F726D223B693A313B733A343A226E6F6465223B693A323B693A343B7D','',61,6,1,'admin/structure/types/manage/%','admin/structure/types/manage/%','Manage fields','t','','','a:0:{}',132,'','',1,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/fields/%',X'613A323A7B693A343B613A313A7B733A31343A226E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A363B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A363B7D','',122,7,0,'','admin/structure/types/manage/%/fields/%','','field_ui_menu_title','a:1:{i:0;i:6;}','','a:0:{}',6,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/fields/%/delete',X'613A323A7B693A343B613A313A7B733A31343A226E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A363B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32363A226669656C645F75695F6669656C645F64656C6574655F666F726D223B693A313B693A363B7D','',245,8,1,'admin/structure/types/manage/%/fields/%','admin/structure/types/manage/%/fields/%','Delete','t','','','a:0:{}',132,'','',10,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/fields/%/edit',X'613A323A7B693A343B613A313A7B733A31343A226E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A363B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32343A226669656C645F75695F6669656C645F656469745F666F726D223B693A313B693A363B7D','',245,8,1,'admin/structure/types/manage/%/fields/%','admin/structure/types/manage/%/fields/%','Edit','t','','','a:0:{}',140,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/fields/%/field-settings',X'613A323A7B693A343B613A313A7B733A31343A226E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A363B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226669656C645F75695F6669656C645F73657474696E67735F666F726D223B693A313B693A363B7D','',245,8,1,'admin/structure/types/manage/%/fields/%','admin/structure/types/manage/%/fields/%','Field settings','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/structure/types/manage/%/fields/%/widget-type',X'613A323A7B693A343B613A313A7B733A31343A226E6F64655F747970655F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D693A363B613A313A7B733A31383A226669656C645F75695F6D656E755F6C6F6164223B613A343A7B693A303B733A343A226E6F6465223B693A313B693A343B693A323B733A313A2234223B693A333B733A343A22256D6170223B7D7D7D','','user_access',X'613A313A7B693A303B733A32343A2261646D696E697374657220636F6E74656E74207479706573223B7D','drupal_get_form',X'613A323A7B693A303B733A32353A226669656C645F75695F7769646765745F747970655F666F726D223B693A313B693A363B7D','',245,8,1,'admin/structure/types/manage/%/fields/%','admin/structure/types/manage/%/fields/%','Widget type','t','','','a:0:{}',132,'','',0,'modules/field_ui/field_ui.admin.inc'),
	('admin/tasks','','','user_access',X'613A313A7B693A303B733A32373A226163636573732061646D696E697374726174696F6E207061676573223B7D','system_admin_menu_block_page',X'613A303A7B7D','',3,2,1,'admin','admin','Tasks','t','','','a:0:{}',140,'','',-20,'modules/system/system.admin.inc'),
	('batch','','','1',X'613A303A7B7D','system_batch_page',X'613A303A7B7D','',1,1,0,'','batch','','t','','_system_batch_theme','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('comment/%',X'613A313A7B693A313B4E3B7D','','user_access',X'613A313A7B693A303B733A31353A2261636365737320636F6D6D656E7473223B7D','comment_permalink',X'613A313A7B693A303B693A313B7D','',2,2,0,'','comment/%','Comment permalink','t','','','a:0:{}',6,'','',0,''),
	('comment/%/approve',X'613A313A7B693A313B4E3B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E697374657220636F6D6D656E7473223B7D','comment_approve',X'613A313A7B693A303B693A313B7D','',5,3,0,'','comment/%/approve','Approve','t','','','a:0:{}',6,'','',1,'modules/comment/comment.pages.inc'),
	('comment/%/delete',X'613A313A7B693A313B4E3B7D','','user_access',X'613A313A7B693A303B733A31393A2261646D696E697374657220636F6D6D656E7473223B7D','comment_confirm_delete_page',X'613A313A7B693A303B693A313B7D','',5,3,1,'comment/%','comment/%','Delete','t','','','a:0:{}',132,'','',2,'modules/comment/comment.admin.inc'),
	('comment/%/edit',X'613A313A7B693A313B733A31323A22636F6D6D656E745F6C6F6164223B7D','','comment_access',X'613A323A7B693A303B733A343A2265646974223B693A313B693A313B7D','comment_edit_page',X'613A313A7B693A303B693A313B7D','',5,3,1,'comment/%','comment/%','Edit','t','','','a:0:{}',132,'','',0,''),
	('comment/%/view',X'613A313A7B693A313B4E3B7D','','user_access',X'613A313A7B693A303B733A31353A2261636365737320636F6D6D656E7473223B7D','comment_permalink',X'613A313A7B693A303B693A313B7D','',5,3,1,'comment/%','comment/%','View comment','t','','','a:0:{}',140,'','',-10,''),
	('comment/reply/%',X'613A313A7B693A323B733A393A226E6F64655F6C6F6164223B7D','','node_access',X'613A323A7B693A303B733A343A2276696577223B693A313B693A323B7D','comment_reply',X'613A313A7B693A303B693A323B7D','',6,3,0,'','comment/reply/%','Add new comment','t','','','a:0:{}',6,'','',0,'modules/comment/comment.pages.inc'),
	('file/ajax','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','file_ajax_upload',X'613A303A7B7D','ajax_deliver',3,2,0,'','file/ajax','','t','','ajax_base_page_theme','a:0:{}',0,'','',0,''),
	('file/progress','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','file_ajax_progress',X'613A303A7B7D','',3,2,0,'','file/progress','','t','','ajax_base_page_theme','a:0:{}',0,'','',0,''),
	('filter/tips','','','1',X'613A303A7B7D','filter_tips_long',X'613A303A7B7D','',3,2,0,'','filter/tips','Compose tips','t','','','a:0:{}',20,'','',0,'modules/filter/filter.pages.inc'),
	('node','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','node_page_default',X'613A303A7B7D','',1,1,0,'','node','','t','','','a:0:{}',0,'','',0,''),
	('node/%',X'613A313A7B693A313B733A393A226E6F64655F6C6F6164223B7D','','node_access',X'613A323A7B693A303B733A343A2276696577223B693A313B693A313B7D','node_page_view',X'613A313A7B693A303B693A313B7D','',2,2,0,'','node/%','','node_page_title','a:1:{i:0;i:1;}','','a:0:{}',6,'','',0,''),
	('node/%/delete',X'613A313A7B693A313B733A393A226E6F64655F6C6F6164223B7D','','node_access',X'613A323A7B693A303B733A363A2264656C657465223B693A313B693A313B7D','drupal_get_form',X'613A323A7B693A303B733A31393A226E6F64655F64656C6574655F636F6E6669726D223B693A313B693A313B7D','',5,3,2,'node/%','node/%','Delete','t','','','a:0:{}',132,'','',1,'modules/node/node.pages.inc'),
	('node/%/edit',X'613A313A7B693A313B733A393A226E6F64655F6C6F6164223B7D','','node_access',X'613A323A7B693A303B733A363A22757064617465223B693A313B693A313B7D','node_page_edit',X'613A313A7B693A303B693A313B7D','',5,3,3,'node/%','node/%','Edit','t','','','a:0:{}',132,'','',0,'modules/node/node.pages.inc'),
	('node/%/revisions',X'613A313A7B693A313B733A393A226E6F64655F6C6F6164223B7D','','_node_revision_access',X'613A313A7B693A303B693A313B7D','node_revision_overview',X'613A313A7B693A303B693A313B7D','',5,3,1,'node/%','node/%','Revisions','t','','','a:0:{}',132,'','',2,'modules/node/node.pages.inc'),
	('node/%/revisions/%/delete',X'613A323A7B693A313B613A313A7B733A393A226E6F64655F6C6F6164223B613A313A7B693A303B693A333B7D7D693A333B4E3B7D','','_node_revision_access',X'613A323A7B693A303B693A313B693A313B733A363A2264656C657465223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226E6F64655F7265766973696F6E5F64656C6574655F636F6E6669726D223B693A313B693A313B7D','',21,5,0,'','node/%/revisions/%/delete','Delete earlier revision','t','','','a:0:{}',6,'','',0,'modules/node/node.pages.inc'),
	('node/%/revisions/%/revert',X'613A323A7B693A313B613A313A7B733A393A226E6F64655F6C6F6164223B613A313A7B693A303B693A333B7D7D693A333B4E3B7D','','_node_revision_access',X'613A323A7B693A303B693A313B693A313B733A363A22757064617465223B7D','drupal_get_form',X'613A323A7B693A303B733A32383A226E6F64655F7265766973696F6E5F7265766572745F636F6E6669726D223B693A313B693A313B7D','',21,5,0,'','node/%/revisions/%/revert','Revert to earlier revision','t','','','a:0:{}',6,'','',0,'modules/node/node.pages.inc'),
	('node/%/revisions/%/view',X'613A323A7B693A313B613A313A7B733A393A226E6F64655F6C6F6164223B613A313A7B693A303B693A333B7D7D693A333B4E3B7D','','_node_revision_access',X'613A313A7B693A303B693A313B7D','node_show',X'613A323A7B693A303B693A313B693A313B623A313B7D','',21,5,0,'','node/%/revisions/%/view','Revisions','t','','','a:0:{}',6,'','',0,''),
	('node/%/view',X'613A313A7B693A313B733A393A226E6F64655F6C6F6164223B7D','','node_access',X'613A323A7B693A303B733A343A2276696577223B693A313B693A313B7D','node_page_view',X'613A313A7B693A303B693A313B7D','',5,3,1,'node/%','node/%','View','t','','','a:0:{}',140,'','',-10,''),
	('node/add','','','_node_add_access',X'613A303A7B7D','node_add_page',X'613A303A7B7D','',3,2,0,'','node/add','Add content','t','','','a:0:{}',6,'','',0,'modules/node/node.pages.inc'),
	('node/add/article','','','node_access',X'613A323A7B693A303B733A363A22637265617465223B693A313B733A373A2261727469636C65223B7D','node_add',X'613A313A7B693A303B733A373A2261727469636C65223B7D','',7,3,0,'','node/add/article','Article','check_plain','','','a:0:{}',6,'Use <em>articles</em> for time-sensitive content like news, press releases or blog posts.','',0,'modules/node/node.pages.inc'),
	('node/add/page','','','node_access',X'613A323A7B693A303B733A363A22637265617465223B693A313B733A343A2270616765223B7D','node_add',X'613A313A7B693A303B733A343A2270616765223B7D','',7,3,0,'','node/add/page','Basic page','check_plain','','','a:0:{}',6,'Use <em>basic pages</em> for your static content, such as an \'About us\' page.','',0,'modules/node/node.pages.inc'),
	('overlay-ajax/%',X'613A313A7B693A313B4E3B7D','','user_access',X'613A313A7B693A303B733A31343A22616363657373206F7665726C6179223B7D','overlay_ajax_render_region',X'613A313A7B693A303B693A313B7D','',2,2,0,'','overlay-ajax/%','','t','','','a:0:{}',0,'','',0,''),
	('overlay/dismiss-message','','','user_access',X'613A313A7B693A303B733A31343A22616363657373206F7665726C6179223B7D','overlay_user_dismiss_message',X'613A303A7B7D','',3,2,0,'','overlay/dismiss-message','','t','','','a:0:{}',0,'','',0,''),
	('rss.xml','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','node_feed',X'613A323A7B693A303B623A303B693A313B613A303A7B7D7D','',1,1,0,'','rss.xml','RSS feed','t','','','a:0:{}',0,'','',0,''),
	('search','','','search_is_active',X'613A303A7B7D','search_view',X'613A303A7B7D','',1,1,0,'','search','Search','t','','','a:0:{}',20,'','',0,'modules/search/search.pages.inc'),
	('search/node','','','_search_menu_access',X'613A313A7B693A303B733A343A226E6F6465223B7D','search_view',X'613A323A7B693A303B733A343A226E6F6465223B693A313B733A303A22223B7D','',3,2,1,'search','search','Content','t','','','a:0:{}',132,'','',-10,'modules/search/search.pages.inc'),
	('search/node/%',X'613A313A7B693A323B613A313A7B733A31343A226D656E755F7461696C5F6C6F6164223B613A323A7B693A303B733A343A22256D6170223B693A313B733A363A2225696E646578223B7D7D7D',X'613A313A7B693A323B733A31363A226D656E755F7461696C5F746F5F617267223B7D','_search_menu_access',X'613A313A7B693A303B733A343A226E6F6465223B7D','search_view',X'613A323A7B693A303B733A343A226E6F6465223B693A313B693A323B7D','',6,3,1,'search/node','search/node/%','Content','t','','','a:0:{}',132,'','',0,'modules/search/search.pages.inc'),
	('search/user','','','_search_menu_access',X'613A313A7B693A303B733A343A2275736572223B7D','search_view',X'613A323A7B693A303B733A343A2275736572223B693A313B733A303A22223B7D','',3,2,1,'search','search','Users','t','','','a:0:{}',132,'','',0,'modules/search/search.pages.inc'),
	('search/user/%',X'613A313A7B693A323B613A313A7B733A31343A226D656E755F7461696C5F6C6F6164223B613A323A7B693A303B733A343A22256D6170223B693A313B733A363A2225696E646578223B7D7D7D',X'613A313A7B693A323B733A31363A226D656E755F7461696C5F746F5F617267223B7D','_search_menu_access',X'613A313A7B693A303B733A343A2275736572223B7D','search_view',X'613A323A7B693A303B733A343A2275736572223B693A313B693A323B7D','',6,3,1,'search/node','search/node/%','Users','t','','','a:0:{}',132,'','',0,'modules/search/search.pages.inc'),
	('sites/default/files/styles/%',X'613A313A7B693A343B733A31363A22696D6167655F7374796C655F6C6F6164223B7D','','1',X'613A303A7B7D','image_style_deliver',X'613A313A7B693A303B693A343B7D','',30,5,0,'','sites/default/files/styles/%','Generate image style','t','','','a:0:{}',0,'','',0,''),
	('system/ajax','','','1',X'613A303A7B7D','ajax_form_callback',X'613A303A7B7D','ajax_deliver',3,2,0,'','system/ajax','AHAH callback','t','','ajax_base_page_theme','a:0:{}',0,'','',0,'includes/form.inc'),
	('system/files','','','1',X'613A303A7B7D','file_download',X'613A313A7B693A303B733A373A2270726976617465223B7D','',3,2,0,'','system/files','File download','t','','','a:0:{}',0,'','',0,''),
	('system/files/styles/%',X'613A313A7B693A333B733A31363A22696D6167655F7374796C655F6C6F6164223B7D','','1',X'613A303A7B7D','image_style_deliver',X'613A313A7B693A303B693A333B7D','',14,4,0,'','system/files/styles/%','Generate image style','t','','','a:0:{}',0,'','',0,''),
	('system/temporary','','','1',X'613A303A7B7D','file_download',X'613A313A7B693A303B733A393A2274656D706F72617279223B7D','',3,2,0,'','system/temporary','Temporary files','t','','','a:0:{}',0,'','',0,''),
	('system/timezone','','','1',X'613A303A7B7D','system_timezone',X'613A303A7B7D','',3,2,0,'','system/timezone','Time zone','t','','','a:0:{}',0,'','',0,'modules/system/system.admin.inc'),
	('taxonomy/autocomplete','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','taxonomy_autocomplete',X'613A303A7B7D','',3,2,0,'','taxonomy/autocomplete','Autocomplete taxonomy','t','','','a:0:{}',0,'','',0,'modules/taxonomy/taxonomy.pages.inc'),
	('taxonomy/term/%',X'613A313A7B693A323B733A31383A227461786F6E6F6D795F7465726D5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','taxonomy_term_page',X'613A313A7B693A303B693A323B7D','',6,3,0,'','taxonomy/term/%','Taxonomy term','taxonomy_term_title','a:1:{i:0;i:2;}','','a:0:{}',6,'','',0,'modules/taxonomy/taxonomy.pages.inc'),
	('taxonomy/term/%/edit',X'613A313A7B693A323B733A31383A227461786F6E6F6D795F7465726D5F6C6F6164223B7D','','taxonomy_term_edit_access',X'613A313A7B693A303B693A323B7D','drupal_get_form',X'613A333A7B693A303B733A31383A227461786F6E6F6D795F666F726D5F7465726D223B693A313B693A323B693A323B4E3B7D','',13,4,1,'taxonomy/term/%','taxonomy/term/%','Edit','t','','','a:0:{}',132,'','',10,'modules/taxonomy/taxonomy.admin.inc'),
	('taxonomy/term/%/feed',X'613A313A7B693A323B733A31383A227461786F6E6F6D795F7465726D5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','taxonomy_term_feed',X'613A313A7B693A303B693A323B7D','',13,4,0,'','taxonomy/term/%/feed','Taxonomy term','taxonomy_term_title','a:1:{i:0;i:2;}','','a:0:{}',0,'','',0,'modules/taxonomy/taxonomy.pages.inc'),
	('taxonomy/term/%/view',X'613A313A7B693A323B733A31383A227461786F6E6F6D795F7465726D5F6C6F6164223B7D','','user_access',X'613A313A7B693A303B733A31343A2261636365737320636F6E74656E74223B7D','taxonomy_term_page',X'613A313A7B693A303B693A323B7D','',13,4,1,'taxonomy/term/%','taxonomy/term/%','View','t','','','a:0:{}',140,'','',0,'modules/taxonomy/taxonomy.pages.inc'),
	('toolbar/toggle','','','user_access',X'613A313A7B693A303B733A31343A2261636365737320746F6F6C626172223B7D','toolbar_toggle_page',X'613A303A7B7D','',3,2,0,'','toolbar/toggle','Toggle drawer visibility','t','','','a:0:{}',0,'','',0,''),
	('user','','','1',X'613A303A7B7D','user_page',X'613A303A7B7D','',1,1,0,'','user','User account','user_menu_title','','','a:0:{}',6,'','',-10,'modules/user/user.pages.inc'),
	('user/%',X'613A313A7B693A313B733A393A22757365725F6C6F6164223B7D','','user_view_access',X'613A313A7B693A303B693A313B7D','user_view_page',X'613A313A7B693A303B693A313B7D','',2,2,0,'','user/%','My account','user_page_title','a:1:{i:0;i:1;}','','a:0:{}',6,'','',0,''),
	('user/%/cancel',X'613A313A7B693A313B733A393A22757365725F6C6F6164223B7D','','user_cancel_access',X'613A313A7B693A303B693A313B7D','drupal_get_form',X'613A323A7B693A303B733A32343A22757365725F63616E63656C5F636F6E6669726D5F666F726D223B693A313B693A313B7D','',5,3,0,'','user/%/cancel','Cancel account','t','','','a:0:{}',6,'','',0,'modules/user/user.pages.inc'),
	('user/%/cancel/confirm/%/%',X'613A333A7B693A313B733A393A22757365725F6C6F6164223B693A343B4E3B693A353B4E3B7D','','user_cancel_access',X'613A313A7B693A303B693A313B7D','user_cancel_confirm',X'613A333A7B693A303B693A313B693A313B693A343B693A323B693A353B7D','',44,6,0,'','user/%/cancel/confirm/%/%','Confirm account cancellation','t','','','a:0:{}',6,'','',0,'modules/user/user.pages.inc'),
	('user/%/edit',X'613A313A7B693A313B733A393A22757365725F6C6F6164223B7D','','user_edit_access',X'613A313A7B693A303B693A313B7D','drupal_get_form',X'613A323A7B693A303B733A31373A22757365725F70726F66696C655F666F726D223B693A313B693A313B7D','',5,3,1,'user/%','user/%','Edit','t','','','a:0:{}',132,'','',0,'modules/user/user.pages.inc'),
	('user/%/edit/account',X'613A313A7B693A313B613A313A7B733A31383A22757365725F63617465676F72795F6C6F6164223B613A323A7B693A303B733A343A22256D6170223B693A313B733A363A2225696E646578223B7D7D7D','','user_edit_access',X'613A313A7B693A303B693A313B7D','drupal_get_form',X'613A323A7B693A303B733A31373A22757365725F70726F66696C655F666F726D223B693A313B693A313B7D','',11,4,1,'user/%/edit','user/%','Account','t','','','a:0:{}',140,'','',0,'modules/user/user.pages.inc'),
	('user/%/shortcuts',X'613A313A7B693A313B733A393A22757365725F6C6F6164223B7D','','shortcut_set_switch_access',X'613A313A7B693A303B693A313B7D','drupal_get_form',X'613A323A7B693A303B733A31393A2273686F72746375745F7365745F737769746368223B693A313B693A313B7D','',5,3,1,'user/%','user/%','Shortcuts','t','','','a:0:{}',132,'','',0,'modules/shortcut/shortcut.admin.inc'),
	('user/%/view',X'613A313A7B693A313B733A393A22757365725F6C6F6164223B7D','','user_view_access',X'613A313A7B693A303B693A313B7D','user_view_page',X'613A313A7B693A303B693A313B7D','',5,3,1,'user/%','user/%','View','t','','','a:0:{}',140,'','',-10,''),
	('user/autocomplete','','','user_access',X'613A313A7B693A303B733A32303A2261636365737320757365722070726F66696C6573223B7D','user_autocomplete',X'613A303A7B7D','',3,2,0,'','user/autocomplete','User autocomplete','t','','','a:0:{}',0,'','',0,'modules/user/user.pages.inc'),
	('user/login','','','user_is_anonymous',X'613A303A7B7D','user_page',X'613A303A7B7D','',3,2,1,'user','user','Log in','t','','','a:0:{}',140,'','',0,'modules/user/user.pages.inc'),
	('user/logout','','','user_is_logged_in',X'613A303A7B7D','user_logout',X'613A303A7B7D','',3,2,0,'','user/logout','Log out','t','','','a:0:{}',6,'','',10,'modules/user/user.pages.inc'),
	('user/password','','','1',X'613A303A7B7D','drupal_get_form',X'613A313A7B693A303B733A393A22757365725F70617373223B7D','',3,2,1,'user','user','Request new password','t','','','a:0:{}',132,'','',0,'modules/user/user.pages.inc'),
	('user/register','','','user_register_access',X'613A303A7B7D','drupal_get_form',X'613A313A7B693A303B733A31383A22757365725F72656769737465725F666F726D223B7D','',3,2,1,'user','user','Create new account','t','','','a:0:{}',132,'','',0,''),
	('user/reset/%/%/%',X'613A333A7B693A323B4E3B693A333B4E3B693A343B4E3B7D','','1',X'613A303A7B7D','drupal_get_form',X'613A343A7B693A303B733A31353A22757365725F706173735F7265736574223B693A313B693A323B693A323B693A333B693A333B693A343B7D','',24,5,0,'','user/reset/%/%/%','Reset password','t','','','a:0:{}',0,'','',0,'modules/user/user.pages.inc');

/*!40000 ALTER TABLE `menu_router` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table node
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node`;

CREATE TABLE `node` (
  `nid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for a node.',
  `vid` int(10) unsigned DEFAULT NULL COMMENT 'The current node_revision.vid version identifier.',
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT 'The node_type.type of this node.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The languages.language of this node.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this node, always treated as non-markup plain text.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that owns this node; initially, this is the user that created it.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node is published (visible to non-administrators).',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  `changed` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was most recently saved.',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node: 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node should be displayed at the top of lists in which it appears.',
  `tnid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The translation set id for this node, which equals the node id of the source post in each set.',
  `translate` int(11) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this translation page needs to be updated.',
  PRIMARY KEY (`nid`),
  UNIQUE KEY `vid` (`vid`),
  KEY `node_changed` (`changed`),
  KEY `node_created` (`created`),
  KEY `node_frontpage` (`promote`,`status`,`sticky`,`created`),
  KEY `node_status_type` (`status`,`type`,`nid`),
  KEY `node_title_type` (`title`,`type`(4)),
  KEY `node_type` (`type`(4)),
  KEY `uid` (`uid`),
  KEY `tnid` (`tnid`),
  KEY `translate` (`translate`),
  KEY `language` (`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='The base table for nodes.';



# Dump of table node_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node_access`;

CREATE TABLE `node_access` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid this record affects.',
  `gid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The grant ID a user must possess in the specified realm to gain this row’s privileges on the node.',
  `realm` varchar(255) NOT NULL DEFAULT '' COMMENT 'The realm in which the user must possess the grant ID. Each node access node can define one or more realms.',
  `grant_view` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can view this node.',
  `grant_update` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can edit this node.',
  `grant_delete` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether a user with the realm/grant pair can delete this node.',
  PRIMARY KEY (`nid`,`gid`,`realm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Identifies which realm/grant pairs a user must possess in...';

LOCK TABLES `node_access` WRITE;
/*!40000 ALTER TABLE `node_access` DISABLE KEYS */;

INSERT INTO `node_access` (`nid`, `gid`, `realm`, `grant_view`, `grant_update`, `grant_delete`)
VALUES
	(0,0,'all',1,0,0);

/*!40000 ALTER TABLE `node_access` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table node_comment_statistics
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node_comment_statistics`;

CREATE TABLE `node_comment_statistics` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid for which the statistics are compiled.',
  `cid` int(11) NOT NULL DEFAULT '0' COMMENT 'The comment.cid of the last comment.',
  `last_comment_timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp of the last comment that was posted within this node, from comment.changed.',
  `last_comment_name` varchar(60) DEFAULT NULL COMMENT 'The name of the latest author to post a comment on this node, from comment.name.',
  `last_comment_uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The user ID of the latest author to post a comment on this node, from comment.uid.',
  `comment_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The total number of comments on this node.',
  PRIMARY KEY (`nid`),
  KEY `node_comment_timestamp` (`last_comment_timestamp`),
  KEY `comment_count` (`comment_count`),
  KEY `last_comment_uid` (`last_comment_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maintains statistics of node and comments posts to show ...';



# Dump of table node_revision
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node_revision`;

CREATE TABLE `node_revision` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node this version belongs to.',
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The primary identifier for this version.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid that created this version.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of this version.',
  `log` longtext NOT NULL COMMENT 'The log entry explaining the changes in this version.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'A Unix timestamp indicating when this version was created.',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT 'Boolean indicating whether the node (at the time of this revision) is published (visible to non-administrators).',
  `comment` int(11) NOT NULL DEFAULT '0' COMMENT 'Whether comments are allowed on this node (at the time of this revision): 0 = no, 1 = closed (read only), 2 = open (read/write).',
  `promote` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed on the front page.',
  `sticky` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether the node (at the time of this revision) should be displayed at the top of lists in which it appears.',
  PRIMARY KEY (`vid`),
  KEY `nid` (`nid`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores information about each saved version of a node.';



# Dump of table node_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `node_type`;

CREATE TABLE `node_type` (
  `type` varchar(32) NOT NULL COMMENT 'The machine-readable name of this type.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The human-readable name of this type.',
  `base` varchar(255) NOT NULL COMMENT 'The base string used to construct callbacks corresponding to this node type.',
  `module` varchar(255) NOT NULL COMMENT 'The module defining this node type.',
  `description` mediumtext NOT NULL COMMENT 'A brief description of this type.',
  `help` mediumtext NOT NULL COMMENT 'Help information shown to the user when creating a node of this type.',
  `has_title` tinyint(3) unsigned NOT NULL COMMENT 'Boolean indicating whether this type uses the node.title field.',
  `title_label` varchar(255) NOT NULL DEFAULT '' COMMENT 'The label displayed for the title field on the edit form.',
  `custom` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this type is defined by a module (FALSE) or by a user via Add content type (TRUE).',
  `modified` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this type has been modified by an administrator; currently not used in any way.',
  `locked` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether the administrator can change the machine name of this type.',
  `disabled` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether the node type is disabled.',
  `orig_type` varchar(255) NOT NULL DEFAULT '' COMMENT 'The original machine-readable name of this node type. This may be different from the current type name if the locked field is 0.',
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores information about all defined node types.';

LOCK TABLES `node_type` WRITE;
/*!40000 ALTER TABLE `node_type` DISABLE KEYS */;

INSERT INTO `node_type` (`type`, `name`, `base`, `module`, `description`, `help`, `has_title`, `title_label`, `custom`, `modified`, `locked`, `disabled`, `orig_type`)
VALUES
	('article','Article','node_content','node','Use <em>articles</em> for time-sensitive content like news, press releases or blog posts.','',1,'Title',1,1,0,0,'article'),
	('page','Basic page','node_content','node','Use <em>basic pages</em> for your static content, such as an \'About us\' page.','',1,'Title',1,1,0,0,'page');

/*!40000 ALTER TABLE `node_type` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table queue
# ------------------------------------------------------------

DROP TABLE IF EXISTS `queue`;

CREATE TABLE `queue` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique item ID.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The queue name.',
  `data` longblob COMMENT 'The arbitrary data for the item.',
  `expire` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp when the claim lease expires on the item.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp when the item was created.',
  PRIMARY KEY (`item_id`),
  KEY `name_created` (`name`,`created`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores items in queues.';



# Dump of table rdf_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `rdf_mapping`;

CREATE TABLE `rdf_mapping` (
  `type` varchar(128) NOT NULL COMMENT 'The name of the entity type a mapping applies to (node, user, comment, etc.).',
  `bundle` varchar(128) NOT NULL COMMENT 'The name of the bundle a mapping applies to.',
  `mapping` longblob COMMENT 'The serialized mapping of the bundle type and fields to RDF terms.',
  PRIMARY KEY (`type`,`bundle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores custom RDF mappings for user defined content types...';

LOCK TABLES `rdf_mapping` WRITE;
/*!40000 ALTER TABLE `rdf_mapping` DISABLE KEYS */;

INSERT INTO `rdf_mapping` (`type`, `bundle`, `mapping`)
VALUES
	('node','article',X'613A31313A7B733A31313A226669656C645F696D616765223B613A323A7B733A31303A2270726564696361746573223B613A323A7B693A303B733A383A226F673A696D616765223B693A313B733A31323A22726466733A736565416C736F223B7D733A343A2274797065223B733A333A2272656C223B7D733A31303A226669656C645F74616773223B613A323A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31303A2264633A7375626A656374223B7D733A343A2274797065223B733A333A2272656C223B7D733A373A2272646674797065223B613A323A7B693A303B733A393A2273696F633A4974656D223B693A313B733A31333A22666F61663A446F63756D656E74223B7D733A353A227469746C65223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A383A2264633A7469746C65223B7D7D733A373A2263726561746564223B613A333A7B733A31303A2270726564696361746573223B613A323A7B693A303B733A373A2264633A64617465223B693A313B733A31303A2264633A63726561746564223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D733A373A226368616E676564223B613A333A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31313A2264633A6D6F646966696564223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D733A343A22626F6479223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31353A22636F6E74656E743A656E636F646564223B7D7D733A333A22756964223B613A323A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31363A2273696F633A6861735F63726561746F72223B7D733A343A2274797065223B733A333A2272656C223B7D733A343A226E616D65223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A393A22666F61663A6E616D65223B7D7D733A31333A22636F6D6D656E745F636F756E74223B613A323A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31363A2273696F633A6E756D5F7265706C696573223B7D733A383A226461746174797065223B733A31313A227873643A696E7465676572223B7D733A31333A226C6173745F6163746976697479223B613A333A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A32333A2273696F633A6C6173745F61637469766974795F64617465223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D7D'),
	('node','page',X'613A393A7B733A373A2272646674797065223B613A313A7B693A303B733A31333A22666F61663A446F63756D656E74223B7D733A353A227469746C65223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A383A2264633A7469746C65223B7D7D733A373A2263726561746564223B613A333A7B733A31303A2270726564696361746573223B613A323A7B693A303B733A373A2264633A64617465223B693A313B733A31303A2264633A63726561746564223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D733A373A226368616E676564223B613A333A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31313A2264633A6D6F646966696564223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D733A343A22626F6479223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31353A22636F6E74656E743A656E636F646564223B7D7D733A333A22756964223B613A323A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31363A2273696F633A6861735F63726561746F72223B7D733A343A2274797065223B733A333A2272656C223B7D733A343A226E616D65223B613A313A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A393A22666F61663A6E616D65223B7D7D733A31333A22636F6D6D656E745F636F756E74223B613A323A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A31363A2273696F633A6E756D5F7265706C696573223B7D733A383A226461746174797065223B733A31313A227873643A696E7465676572223B7D733A31333A226C6173745F6163746976697479223B613A333A7B733A31303A2270726564696361746573223B613A313A7B693A303B733A32333A2273696F633A6C6173745F61637469766974795F64617465223B7D733A383A226461746174797065223B733A31323A227873643A6461746554696D65223B733A383A2263616C6C6261636B223B733A31323A22646174655F69736F38363031223B7D7D');

/*!40000 ALTER TABLE `rdf_mapping` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table registry
# ------------------------------------------------------------

DROP TABLE IF EXISTS `registry`;

CREATE TABLE `registry` (
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the function, class, or interface.',
  `type` varchar(9) NOT NULL DEFAULT '' COMMENT 'Either function or class or interface.',
  `filename` varchar(255) NOT NULL COMMENT 'Name of the file.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the module the file belongs to.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The order in which this module’s hooks should be invoked relative to other modules. Equal-weighted modules are ordered by name.',
  PRIMARY KEY (`name`,`type`),
  KEY `hook` (`type`,`weight`,`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Each record is a function, class, or interface name and...';

LOCK TABLES `registry` WRITE;
/*!40000 ALTER TABLE `registry` DISABLE KEYS */;

INSERT INTO `registry` (`name`, `type`, `filename`, `module`, `weight`)
VALUES
	('AccessDeniedTestCase','class','modules/system/system.test','system',0),
	('AdminMetaTagTestCase','class','modules/system/system.test','system',0),
	('ArchiverInterface','interface','includes/archiver.inc','',0),
	('ArchiverTar','class','modules/system/system.archiver.inc','system',0),
	('ArchiverZip','class','modules/system/system.archiver.inc','system',0),
	('Archive_Tar','class','modules/system/system.tar.inc','system',0),
	('BatchMemoryQueue','class','includes/batch.queue.inc','',0),
	('BatchQueue','class','includes/batch.queue.inc','',0),
	('BlockAdminThemeTestCase','class','modules/block/block.test','block',0),
	('BlockCacheTestCase','class','modules/block/block.test','block',0),
	('BlockHashTestCase','class','modules/block/block.test','block',0),
	('BlockHiddenRegionTestCase','class','modules/block/block.test','block',0),
	('BlockHTMLIdTestCase','class','modules/block/block.test','block',0),
	('BlockInvalidRegionTestCase','class','modules/block/block.test','block',0),
	('BlockTemplateSuggestionsUnitTest','class','modules/block/block.test','block',0),
	('BlockTestCase','class','modules/block/block.test','block',0),
	('BlockViewModuleDeltaAlterWebTest','class','modules/block/block.test','block',0),
	('ColorTestCase','class','modules/color/color.test','color',0),
	('CommentActionsTestCase','class','modules/comment/comment.test','comment',0),
	('CommentAnonymous','class','modules/comment/comment.test','comment',0),
	('CommentApprovalTest','class','modules/comment/comment.test','comment',0),
	('CommentBlockFunctionalTest','class','modules/comment/comment.test','comment',0),
	('CommentContentRebuild','class','modules/comment/comment.test','comment',0),
	('CommentController','class','modules/comment/comment.module','comment',0),
	('CommentFieldsTest','class','modules/comment/comment.test','comment',0),
	('CommentHelperCase','class','modules/comment/comment.test','comment',0),
	('CommentInterfaceTest','class','modules/comment/comment.test','comment',0),
	('CommentNodeAccessTest','class','modules/comment/comment.test','comment',0),
	('CommentNodeChangesTestCase','class','modules/comment/comment.test','comment',0),
	('CommentPagerTest','class','modules/comment/comment.test','comment',0),
	('CommentPreviewTest','class','modules/comment/comment.test','comment',0),
	('CommentRSSUnitTest','class','modules/comment/comment.test','comment',0),
	('CommentThreadingTestCase','class','modules/comment/comment.test','comment',0),
	('CommentTokenReplaceTestCase','class','modules/comment/comment.test','comment',0),
	('ConfirmFormTest','class','modules/system/system.test','system',0),
	('ContextualDynamicContextTestCase','class','modules/contextual/contextual.test','contextual',0),
	('CronQueueTestCase','class','modules/system/system.test','system',0),
	('CronRunTestCase','class','modules/system/system.test','system',0),
	('DashboardBlocksTestCase','class','modules/dashboard/dashboard.test','dashboard',0),
	('Database','class','includes/database/database.inc','',0),
	('DatabaseCondition','class','includes/database/query.inc','',0),
	('DatabaseConnection','class','includes/database/database.inc','',0),
	('DatabaseConnectionNotDefinedException','class','includes/database/database.inc','',0),
	('DatabaseConnection_mysql','class','includes/database/mysql/database.inc','',0),
	('DatabaseConnection_pgsql','class','includes/database/pgsql/database.inc','',0),
	('DatabaseConnection_sqlite','class','includes/database/sqlite/database.inc','',0),
	('DatabaseDriverNotSpecifiedException','class','includes/database/database.inc','',0),
	('DatabaseLog','class','includes/database/log.inc','',0),
	('DatabaseSchema','class','includes/database/schema.inc','',0),
	('DatabaseSchemaObjectDoesNotExistException','class','includes/database/schema.inc','',0),
	('DatabaseSchemaObjectExistsException','class','includes/database/schema.inc','',0),
	('DatabaseSchema_mysql','class','includes/database/mysql/schema.inc','',0),
	('DatabaseSchema_pgsql','class','includes/database/pgsql/schema.inc','',0),
	('DatabaseSchema_sqlite','class','includes/database/sqlite/schema.inc','',0),
	('DatabaseStatementBase','class','includes/database/database.inc','',0),
	('DatabaseStatementEmpty','class','includes/database/database.inc','',0),
	('DatabaseStatementInterface','interface','includes/database/database.inc','',0),
	('DatabaseStatementPrefetch','class','includes/database/prefetch.inc','',0),
	('DatabaseStatement_sqlite','class','includes/database/sqlite/database.inc','',0),
	('DatabaseTaskException','class','includes/install.inc','',0),
	('DatabaseTasks','class','includes/install.inc','',0),
	('DatabaseTasks_mysql','class','includes/database/mysql/install.inc','',0),
	('DatabaseTasks_pgsql','class','includes/database/pgsql/install.inc','',0),
	('DatabaseTasks_sqlite','class','includes/database/sqlite/install.inc','',0),
	('DatabaseTransaction','class','includes/database/database.inc','',0),
	('DatabaseTransactionCommitFailedException','class','includes/database/database.inc','',0),
	('DatabaseTransactionExplicitCommitNotAllowedException','class','includes/database/database.inc','',0),
	('DatabaseTransactionNameNonUniqueException','class','includes/database/database.inc','',0),
	('DatabaseTransactionNoActiveException','class','includes/database/database.inc','',0),
	('DatabaseTransactionOutOfOrderException','class','includes/database/database.inc','',0),
	('DateTimeFunctionalTest','class','modules/system/system.test','system',0),
	('DBLogTestCase','class','modules/dblog/dblog.test','dblog',0),
	('DefaultMailSystem','class','modules/system/system.mail.inc','system',0),
	('DeleteQuery','class','includes/database/query.inc','',0),
	('DeleteQuery_sqlite','class','includes/database/sqlite/query.inc','',0),
	('DrupalCacheArray','class','includes/bootstrap.inc','',0),
	('DrupalCacheInterface','interface','includes/cache.inc','',0),
	('DrupalDatabaseCache','class','includes/cache.inc','',0),
	('DrupalDefaultEntityController','class','includes/entity.inc','',0),
	('DrupalEntityControllerInterface','interface','includes/entity.inc','',0),
	('DrupalFakeCache','class','includes/cache-install.inc','',0),
	('DrupalLocalStreamWrapper','class','includes/stream_wrappers.inc','',0),
	('DrupalPrivateStreamWrapper','class','includes/stream_wrappers.inc','',0),
	('DrupalPublicStreamWrapper','class','includes/stream_wrappers.inc','',0),
	('DrupalQueue','class','modules/system/system.queue.inc','system',0),
	('DrupalQueueInterface','interface','modules/system/system.queue.inc','system',0),
	('DrupalReliableQueueInterface','interface','modules/system/system.queue.inc','system',0),
	('DrupalSetMessageTest','class','modules/system/system.test','system',0),
	('DrupalStreamWrapperInterface','interface','includes/stream_wrappers.inc','',0),
	('DrupalTemporaryStreamWrapper','class','includes/stream_wrappers.inc','',0),
	('DrupalUpdateException','class','includes/update.inc','',0),
	('DrupalUpdaterInterface','interface','includes/updater.inc','',0),
	('EnableDisableTestCase','class','modules/system/system.test','system',0),
	('EntityFieldQuery','class','includes/entity.inc','',0),
	('EntityFieldQueryException','class','includes/entity.inc','',0),
	('EntityMalformedException','class','includes/entity.inc','',0),
	('EntityPropertiesTestCase','class','modules/field/tests/field.test','field',0),
	('FieldAttachOtherTestCase','class','modules/field/tests/field.test','field',0),
	('FieldAttachStorageTestCase','class','modules/field/tests/field.test','field',0),
	('FieldAttachTestCase','class','modules/field/tests/field.test','field',0),
	('FieldBulkDeleteTestCase','class','modules/field/tests/field.test','field',0),
	('FieldCrudTestCase','class','modules/field/tests/field.test','field',0),
	('FieldDisplayAPITestCase','class','modules/field/tests/field.test','field',0),
	('FieldException','class','modules/field/field.module','field',0),
	('FieldFormTestCase','class','modules/field/tests/field.test','field',0),
	('FieldInfo','class','modules/field/field.info.class.inc','field',0),
	('FieldInfoTestCase','class','modules/field/tests/field.test','field',0),
	('FieldInstanceCrudTestCase','class','modules/field/tests/field.test','field',0),
	('FieldsOverlapException','class','includes/database/database.inc','',0),
	('FieldSqlStorageTestCase','class','modules/field/modules/field_sql_storage/field_sql_storage.test','field_sql_storage',0),
	('FieldTestCase','class','modules/field/tests/field.test','field',0),
	('FieldTranslationsTestCase','class','modules/field/tests/field.test','field',0),
	('FieldUIAlterTestCase','class','modules/field_ui/field_ui.test','field_ui',0),
	('FieldUIManageDisplayTestCase','class','modules/field_ui/field_ui.test','field_ui',0),
	('FieldUIManageFieldsTestCase','class','modules/field_ui/field_ui.test','field_ui',0),
	('FieldUITestCase','class','modules/field_ui/field_ui.test','field_ui',0),
	('FieldUpdateForbiddenException','class','modules/field/field.module','field',0),
	('FieldValidationException','class','modules/field/field.attach.inc','field',0),
	('FileFieldDisplayTestCase','class','modules/file/tests/file.test','file',0),
	('FileFieldPathTestCase','class','modules/file/tests/file.test','file',0),
	('FileFieldRevisionTestCase','class','modules/file/tests/file.test','file',0),
	('FileFieldTestCase','class','modules/file/tests/file.test','file',0),
	('FileFieldValidateTestCase','class','modules/file/tests/file.test','file',0),
	('FileFieldWidgetTestCase','class','modules/file/tests/file.test','file',0),
	('FileManagedFileElementTestCase','class','modules/file/tests/file.test','file',0),
	('FilePrivateTestCase','class','modules/file/tests/file.test','file',0),
	('FileTaxonomyTermTestCase','class','modules/file/tests/file.test','file',0),
	('FileTokenReplaceTestCase','class','modules/file/tests/file.test','file',0),
	('FileTransfer','class','includes/filetransfer/filetransfer.inc','',0),
	('FileTransferChmodInterface','interface','includes/filetransfer/filetransfer.inc','',0),
	('FileTransferException','class','includes/filetransfer/filetransfer.inc','',0),
	('FileTransferFTP','class','includes/filetransfer/ftp.inc','',0),
	('FileTransferFTPExtension','class','includes/filetransfer/ftp.inc','',0),
	('FileTransferLocal','class','includes/filetransfer/local.inc','',0),
	('FileTransferSSH','class','includes/filetransfer/ssh.inc','',0),
	('FilterAdminTestCase','class','modules/filter/filter.test','filter',0),
	('FilterCRUDTestCase','class','modules/filter/filter.test','filter',0),
	('FilterDefaultFormatTestCase','class','modules/filter/filter.test','filter',0),
	('FilterFormatAccessTestCase','class','modules/filter/filter.test','filter',0),
	('FilterHooksTestCase','class','modules/filter/filter.test','filter',0),
	('FilterNoFormatTestCase','class','modules/filter/filter.test','filter',0),
	('FilterSecurityTestCase','class','modules/filter/filter.test','filter',0),
	('FilterSettingsTestCase','class','modules/filter/filter.test','filter',0),
	('FilterUnitTestCase','class','modules/filter/filter.test','filter',0),
	('FloodFunctionalTest','class','modules/system/system.test','system',0),
	('FrontPageTestCase','class','modules/system/system.test','system',0),
	('HelpTestCase','class','modules/help/help.test','help',0),
	('HookRequirementsTestCase','class','modules/system/system.test','system',0),
	('ImageAdminStylesUnitTest','class','modules/image/image.test','image',0),
	('ImageDimensionsScaleTestCase','class','modules/image/image.test','image',0),
	('ImageDimensionsTestCase','class','modules/image/image.test','image',0),
	('ImageEffectsUnitTest','class','modules/image/image.test','image',0),
	('ImageFieldDefaultImagesTestCase','class','modules/image/image.test','image',0),
	('ImageFieldDisplayTestCase','class','modules/image/image.test','image',0),
	('ImageFieldTestCase','class','modules/image/image.test','image',0),
	('ImageFieldValidateTestCase','class','modules/image/image.test','image',0),
	('ImageStyleFlushTest','class','modules/image/image.test','image',0),
	('ImageStylesPathAndUrlTestCase','class','modules/image/image.test','image',0),
	('ImageThemeFunctionWebTestCase','class','modules/image/image.test','image',0),
	('InfoFileParserTestCase','class','modules/system/system.test','system',0),
	('InsertQuery','class','includes/database/query.inc','',0),
	('InsertQuery_mysql','class','includes/database/mysql/query.inc','',0),
	('InsertQuery_pgsql','class','includes/database/pgsql/query.inc','',0),
	('InsertQuery_sqlite','class','includes/database/sqlite/query.inc','',0),
	('InvalidMergeQueryException','class','includes/database/database.inc','',0),
	('IPAddressBlockingTestCase','class','modules/system/system.test','system',0),
	('ListDynamicValuesTestCase','class','modules/field/modules/list/tests/list.test','list',0),
	('ListDynamicValuesValidationTestCase','class','modules/field/modules/list/tests/list.test','list',0),
	('ListFieldTestCase','class','modules/field/modules/list/tests/list.test','list',0),
	('ListFieldUITestCase','class','modules/field/modules/list/tests/list.test','list',0),
	('MailSystemInterface','interface','includes/mail.inc','',0),
	('MemoryQueue','class','modules/system/system.queue.inc','system',0),
	('MenuNodeTestCase','class','modules/menu/menu.test','menu',0),
	('MenuTestCase','class','modules/menu/menu.test','menu',0),
	('MergeQuery','class','includes/database/query.inc','',0),
	('ModuleDependencyTestCase','class','modules/system/system.test','system',0),
	('ModuleRequiredTestCase','class','modules/system/system.test','system',0),
	('ModuleTestCase','class','modules/system/system.test','system',0),
	('ModuleUpdater','class','modules/system/system.updater.inc','system',0),
	('ModuleVersionTestCase','class','modules/system/system.test','system',0),
	('MultiStepNodeFormBasicOptionsTest','class','modules/node/node.test','node',0),
	('NewDefaultThemeBlocks','class','modules/block/block.test','block',0),
	('NodeAccessBaseTableTestCase','class','modules/node/node.test','node',0),
	('NodeAccessFieldTestCase','class','modules/node/node.test','node',0),
	('NodeAccessPagerTestCase','class','modules/node/node.test','node',0),
	('NodeAccessRebuildTestCase','class','modules/node/node.test','node',0),
	('NodeAccessRecordsTestCase','class','modules/node/node.test','node',0),
	('NodeAccessTestCase','class','modules/node/node.test','node',0),
	('NodeAdminTestCase','class','modules/node/node.test','node',0),
	('NodeBlockFunctionalTest','class','modules/node/node.test','node',0),
	('NodeBlockTestCase','class','modules/node/node.test','node',0),
	('NodeBuildContent','class','modules/node/node.test','node',0),
	('NodeController','class','modules/node/node.module','node',0),
	('NodeCreationTestCase','class','modules/node/node.test','node',0),
	('NodeEntityFieldQueryAlter','class','modules/node/node.test','node',0),
	('NodeEntityViewModeAlterTest','class','modules/node/node.test','node',0),
	('NodeFeedTestCase','class','modules/node/node.test','node',0),
	('NodeLoadHooksTestCase','class','modules/node/node.test','node',0),
	('NodeLoadMultipleTestCase','class','modules/node/node.test','node',0),
	('NodePageCacheTest','class','modules/node/node.test','node',0),
	('NodePostSettingsTestCase','class','modules/node/node.test','node',0),
	('NodeQueryAlter','class','modules/node/node.test','node',0),
	('NodeRevisionPermissionsTestCase','class','modules/node/node.test','node',0),
	('NodeRevisionsTestCase','class','modules/node/node.test','node',0),
	('NodeRSSContentTestCase','class','modules/node/node.test','node',0),
	('NodeSaveTestCase','class','modules/node/node.test','node',0),
	('NodeTitleTestCase','class','modules/node/node.test','node',0),
	('NodeTitleXSSTestCase','class','modules/node/node.test','node',0),
	('NodeTokenReplaceTestCase','class','modules/node/node.test','node',0),
	('NodeTypePersistenceTestCase','class','modules/node/node.test','node',0),
	('NodeTypeTestCase','class','modules/node/node.test','node',0),
	('NodeWebTestCase','class','modules/node/node.test','node',0),
	('NoFieldsException','class','includes/database/database.inc','',0),
	('NoHelpTestCase','class','modules/help/help.test','help',0),
	('NonDefaultBlockAdmin','class','modules/block/block.test','block',0),
	('NumberFieldTestCase','class','modules/field/modules/number/number.test','number',0),
	('OptionsSelectDynamicValuesTestCase','class','modules/field/modules/options/options.test','options',0),
	('OptionsWidgetsTestCase','class','modules/field/modules/options/options.test','options',0),
	('PageEditTestCase','class','modules/node/node.test','node',0),
	('PageNotFoundTestCase','class','modules/system/system.test','system',0),
	('PagePreviewTestCase','class','modules/node/node.test','node',0),
	('PagerDefault','class','includes/pager.inc','',0),
	('PageTitleFiltering','class','modules/system/system.test','system',0),
	('PageViewTestCase','class','modules/node/node.test','node',0),
	('PathLanguageTestCase','class','modules/path/path.test','path',0),
	('PathLanguageUITestCase','class','modules/path/path.test','path',0),
	('PathMonolingualTestCase','class','modules/path/path.test','path',0),
	('PathTaxonomyTermTestCase','class','modules/path/path.test','path',0),
	('PathTestCase','class','modules/path/path.test','path',0),
	('Query','class','includes/database/query.inc','',0),
	('QueryAlterableInterface','interface','includes/database/query.inc','',0),
	('QueryConditionInterface','interface','includes/database/query.inc','',0),
	('QueryExtendableInterface','interface','includes/database/select.inc','',0),
	('QueryPlaceholderInterface','interface','includes/database/query.inc','',0),
	('QueueTestCase','class','modules/system/system.test','system',0),
	('RdfCommentAttributesTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfCrudTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfGetRdfNamespacesTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfMappingDefinitionTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfMappingHookTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfRdfaMarkupTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RdfTrackerAttributesTestCase','class','modules/rdf/rdf.test','rdf',0),
	('RetrieveFileTestCase','class','modules/system/system.test','system',0),
	('SchemaCache','class','includes/bootstrap.inc','',0),
	('SearchAdvancedSearchForm','class','modules/search/search.test','search',0),
	('SearchBlockTestCase','class','modules/search/search.test','search',0),
	('SearchCommentCountToggleTestCase','class','modules/search/search.test','search',0),
	('SearchCommentTestCase','class','modules/search/search.test','search',0),
	('SearchConfigSettingsForm','class','modules/search/search.test','search',0),
	('SearchEmbedForm','class','modules/search/search.test','search',0),
	('SearchExactTestCase','class','modules/search/search.test','search',0),
	('SearchExcerptTestCase','class','modules/search/search.test','search',0),
	('SearchExpressionInsertExtractTestCase','class','modules/search/search.test','search',0),
	('SearchKeywordsConditions','class','modules/search/search.test','search',0),
	('SearchLanguageTestCase','class','modules/search/search.test','search',0),
	('SearchMatchTestCase','class','modules/search/search.test','search',0),
	('SearchNodeAccessTest','class','modules/search/search.test','search',0),
	('SearchNodeTagTest','class','modules/search/search.test','search',0),
	('SearchNumberMatchingTestCase','class','modules/search/search.test','search',0),
	('SearchNumbersTestCase','class','modules/search/search.test','search',0),
	('SearchPageOverride','class','modules/search/search.test','search',0),
	('SearchPageText','class','modules/search/search.test','search',0),
	('SearchQuery','class','modules/search/search.extender.inc','search',0),
	('SearchRankingTestCase','class','modules/search/search.test','search',0),
	('SearchSetLocaleTest','class','modules/search/search.test','search',0),
	('SearchSimplifyTestCase','class','modules/search/search.test','search',0),
	('SearchTokenizerTestCase','class','modules/search/search.test','search',0),
	('SelectQuery','class','includes/database/select.inc','',0),
	('SelectQueryExtender','class','includes/database/select.inc','',0),
	('SelectQueryInterface','interface','includes/database/select.inc','',0),
	('SelectQuery_pgsql','class','includes/database/pgsql/select.inc','',0),
	('SelectQuery_sqlite','class','includes/database/sqlite/select.inc','',0),
	('ShortcutLinksTestCase','class','modules/shortcut/shortcut.test','shortcut',0),
	('ShortcutSetsTestCase','class','modules/shortcut/shortcut.test','shortcut',0),
	('ShortcutTestCase','class','modules/shortcut/shortcut.test','shortcut',0),
	('ShutdownFunctionsTest','class','modules/system/system.test','system',0),
	('SiteMaintenanceTestCase','class','modules/system/system.test','system',0),
	('SkipDotsRecursiveDirectoryIterator','class','includes/filetransfer/filetransfer.inc','',0),
	('StreamWrapperInterface','interface','includes/stream_wrappers.inc','',0),
	('SummaryLengthTestCase','class','modules/node/node.test','node',0),
	('SystemAdminTestCase','class','modules/system/system.test','system',0),
	('SystemAuthorizeCase','class','modules/system/system.test','system',0),
	('SystemBlockTestCase','class','modules/system/system.test','system',0),
	('SystemIndexPhpTest','class','modules/system/system.test','system',0),
	('SystemInfoAlterTestCase','class','modules/system/system.test','system',0),
	('SystemMainContentFallback','class','modules/system/system.test','system',0),
	('SystemQueue','class','modules/system/system.queue.inc','system',0),
	('SystemThemeFunctionalTest','class','modules/system/system.test','system',0),
	('SystemValidTokenTest','class','modules/system/system.test','system',0),
	('TableSort','class','includes/tablesort.inc','',0),
	('TaxonomyEFQTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyHooksTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyLegacyTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyLoadMultipleTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyRSSTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTermController','class','modules/taxonomy/taxonomy.module','taxonomy',0),
	('TaxonomyTermFieldMultipleVocabularyTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTermFieldTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTermFunctionTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTermIndexTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTermTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyThemeTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyTokenReplaceTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyVocabularyController','class','modules/taxonomy/taxonomy.module','taxonomy',0),
	('TaxonomyVocabularyFunctionalTest','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyVocabularyTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TaxonomyWebTestCase','class','modules/taxonomy/taxonomy.test','taxonomy',0),
	('TestingMailSystem','class','modules/system/system.mail.inc','system',0),
	('TextFieldTestCase','class','modules/field/modules/text/text.test','text',0),
	('TextSummaryTestCase','class','modules/field/modules/text/text.test','text',0),
	('TextTranslationTestCase','class','modules/field/modules/text/text.test','text',0),
	('ThemeRegistry','class','includes/theme.inc','',0),
	('ThemeUpdater','class','modules/system/system.updater.inc','system',0),
	('TokenReplaceTestCase','class','modules/system/system.test','system',0),
	('TokenScanTest','class','modules/system/system.test','system',0),
	('TruncateQuery','class','includes/database/query.inc','',0),
	('TruncateQuery_mysql','class','includes/database/mysql/query.inc','',0),
	('TruncateQuery_sqlite','class','includes/database/sqlite/query.inc','',0),
	('UpdateQuery','class','includes/database/query.inc','',0),
	('UpdateQuery_pgsql','class','includes/database/pgsql/query.inc','',0),
	('UpdateQuery_sqlite','class','includes/database/sqlite/query.inc','',0),
	('Updater','class','includes/updater.inc','',0),
	('UpdaterException','class','includes/updater.inc','',0),
	('UpdaterFileTransferException','class','includes/updater.inc','',0),
	('UpdateScriptFunctionalTest','class','modules/system/system.test','system',0),
	('UserAccountLinksUnitTests','class','modules/user/user.test','user',0),
	('UserAdminTestCase','class','modules/user/user.test','user',0),
	('UserAuthmapAssignmentTestCase','class','modules/user/user.test','user',0),
	('UserAutocompleteTestCase','class','modules/user/user.test','user',0),
	('UserBlocksUnitTests','class','modules/user/user.test','user',0),
	('UserCancelTestCase','class','modules/user/user.test','user',0),
	('UserController','class','modules/user/user.module','user',0),
	('UserCreateTestCase','class','modules/user/user.test','user',0),
	('UserEditedOwnAccountTestCase','class','modules/user/user.test','user',0),
	('UserEditTestCase','class','modules/user/user.test','user',0),
	('UserLoginTestCase','class','modules/user/user.test','user',0),
	('UserPasswordResetTestCase','class','modules/user/user.test','user',0),
	('UserPermissionsTestCase','class','modules/user/user.test','user',0),
	('UserPictureTestCase','class','modules/user/user.test','user',0),
	('UserRegistrationTestCase','class','modules/user/user.test','user',0),
	('UserRoleAdminTestCase','class','modules/user/user.test','user',0),
	('UserRolesAssignmentTestCase','class','modules/user/user.test','user',0),
	('UserSaveTestCase','class','modules/user/user.test','user',0),
	('UserSignatureTestCase','class','modules/user/user.test','user',0),
	('UserTimeZoneFunctionalTest','class','modules/user/user.test','user',0),
	('UserTokenReplaceTestCase','class','modules/user/user.test','user',0),
	('UserUserSearchTestCase','class','modules/user/user.test','user',0),
	('UserValidateCurrentPassCustomForm','class','modules/user/user.test','user',0),
	('UserValidationTestCase','class','modules/user/user.test','user',0);

/*!40000 ALTER TABLE `registry` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table registry_file
# ------------------------------------------------------------

DROP TABLE IF EXISTS `registry_file`;

CREATE TABLE `registry_file` (
  `filename` varchar(255) NOT NULL COMMENT 'Path to the file.',
  `hash` varchar(64) NOT NULL COMMENT 'sha-256 hash of the file’s contents when last parsed.',
  PRIMARY KEY (`filename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Files parsed to build the registry.';

LOCK TABLES `registry_file` WRITE;
/*!40000 ALTER TABLE `registry_file` DISABLE KEYS */;

INSERT INTO `registry_file` (`filename`, `hash`)
VALUES
	('includes/actions.inc','f36b066681463c7dfe189e0430cb1a89bf66f7e228cbb53cdfcd93987193f759'),
	('includes/ajax.inc','f16049780e1f09a090767ff17594da0a030911cf1c99f8998e2a0cdf8b48d98f'),
	('includes/archiver.inc','bdbb21b712a62f6b913590b609fd17cd9f3c3b77c0d21f68e71a78427ed2e3e9'),
	('includes/authorize.inc','6d64d8c21aa01eb12fc29918732e4df6b871ed06e5d41373cb95c197ed661d13'),
	('includes/batch.inc','059da9e36e1f3717f27840aae73f10dea7d6c8daf16f6520401cc1ca3b4c0388'),
	('includes/batch.queue.inc','554b2e92e1dad0f7fd5a19cb8dff7e109f10fbe2441a5692d076338ec908de0f'),
	('includes/bootstrap.inc','3ab632b42db30a95e97e56176f0c1e2abdf861312bd91ba11e33df9b5e80ade8'),
	('includes/cache-install.inc','e7ed123c5805703c84ad2cce9c1ca46b3ce8caeeea0d8ef39a3024a4ab95fa0e'),
	('includes/cache.inc','d01e10e4c18010b6908026f3d71b72717e3272cfb91a528490eba7f339f8dd1b'),
	('includes/common.inc','42cddc5de615b3f80b7430c949add6ae1f0ca9740807762a38fabc28fd0db072'),
	('includes/database/database.inc','24afaff6e1026bfe315205212cba72951240a16154250e405c4c64724e6e07cc'),
	('includes/database/log.inc','9feb5a17ae2fabcf26a96d2a634ba73da501f7bcfc3599a693d916a6971d00d1'),
	('includes/database/mysql/database.inc','311f6444b3aa9ce44f95a848e407b4418d2b583ecbf70643ffeb61c23a1ae6df'),
	('includes/database/mysql/install.inc','6ae316941f771732fbbabed7e1d6b4cbb41b1f429dd097d04b3345aa15e461a0'),
	('includes/database/mysql/query.inc','0212a871646c223bf77aa26b945c77a8974855373967b5fb9fdc09f8a1de88a6'),
	('includes/database/mysql/schema.inc','6f43ac87508f868fe38ee09994fc18d69915bada0237f8ac3b717cafe8f22c6b'),
	('includes/database/pgsql/database.inc','d737f95947d78eb801e8ec8ca8b01e72d2e305924efce8abca0a98c1b5264cff'),
	('includes/database/pgsql/install.inc','585b80c5bbd6f134bff60d06397f15154657a577d4da8d1b181858905f09dea5'),
	('includes/database/pgsql/query.inc','0df57377686c921e722a10b49d5e433b131176c8059a4ace4680964206fc14b4'),
	('includes/database/pgsql/schema.inc','1588daadfa53506aa1f5d94572162a45a46dc3ceabdd0e2f224532ded6508403'),
	('includes/database/pgsql/select.inc','fd4bba7887c1dc6abc8f080fc3a76c01d92ea085434e355dc1ecb50d8743c22d'),
	('includes/database/prefetch.inc','b5b207a66a69ecb52ee4f4459af16a7b5eabedc87254245f37cc33bebb61c0fb'),
	('includes/database/query.inc','4016a397f10f071cac338fd0a9b004296106e42ab2b9db8c7ff0db341658e88f'),
	('includes/database/schema.inc','a98b69d33975e75f7d99cb85b20c36b7fc10e35a588e07b20c1b37500f5876ca'),
	('includes/database/select.inc','5e9cdc383564ba86cb9dcad0046990ce15415a3000e4f617d6e0f30a205b852c'),
	('includes/database/sqlite/database.inc','4281c6e80932560ecbeb07d1757efd133e8699a6fccf58c27a55df0f71794622'),
	('includes/database/sqlite/install.inc','381f3db8c59837d961978ba3097bb6443534ed1659fd713aa563963fa0c42cc5'),
	('includes/database/sqlite/query.inc','f33ab1b6350736a231a4f3f93012d3aac4431ac4e5510fb3a015a5aa6cab8303'),
	('includes/database/sqlite/schema.inc','cd829700205a8574f8b9d88cd1eaf909519c64754c6f84d6c62b5d21f5886f8d'),
	('includes/database/sqlite/select.inc','8d1c426dbd337733c206cce9f59a172546c6ed856d8ef3f1c7bef05a16f7bf68'),
	('includes/date.inc','18c047be64f201e16d189f1cc47ed9dcf0a145151b1ee187e90511b24e5d2b36'),
	('includes/entity.inc','e4fc9ff21b165a804d7ac4f036b3b5bd1d3c73da7029bf3f761d4bdee9ae3c96'),
	('includes/errors.inc','72cc29840b24830df98a5628286b4d82738f2abbb78e69b4980310ff12062668'),
	('includes/file.inc','7d0fab68c433d8068b67537ffad3ab94ddeffc971ed1339fab915fa90d284e1b'),
	('includes/file.mimetypes.inc','33266e837f4ce076378e7e8cef6c5af46446226ca4259f83e13f605856a7f147'),
	('includes/filetransfer/filetransfer.inc','fdea8ae48345ec91885ac48a9bc53daf87616271472bb7c29b7e3ce219b22034'),
	('includes/filetransfer/ftp.inc','51eb119b8e1221d598ffa6cc46c8a322aa77b49a3d8879f7fb38b7221cf7e06d'),
	('includes/filetransfer/local.inc','7cbfdb46abbdf539640db27e66fb30e5265128f31002bd0dfc3af16ae01a9492'),
	('includes/filetransfer/ssh.inc','92f1232158cb32ab04cbc93ae38ad3af04796e18f66910a9bc5ca8e437f06891'),
	('includes/form.inc','8519720d1472f0a5be270fd1d307412e467394b0632e57d91e08302da554736e'),
	('includes/graph.inc','8e0e313a8bb33488f371df11fc1b58d7cf80099b886cd1003871e2c896d1b536'),
	('includes/image.inc','bcdc7e1599c02227502b9d0fe36eeb2b529b130a392bc709eb737647bd361826'),
	('includes/install.core.inc','83ea48af045d58fab2d6b7101f3229d66ecf6d874ca41ad1cf15bf438d79bcc5'),
	('includes/install.inc','781c54771c14b067bb38d222096f981121d479222fbdea9c433405de561a2881'),
	('includes/iso.inc','0ce4c225edcfa9f037703bc7dd09d4e268a69bcc90e55da0a3f04c502bd2f349'),
	('includes/json-encode.inc','02a822a652d00151f79db9aa9e171c310b69b93a12f549bc2ce00533a8efa14e'),
	('includes/language.inc','4e08f30843a7ccaeea5c041083e9f77d33d57ff002f1ab4f66168e2c683ce128'),
	('includes/locale.inc','b957302ca8912d1f3c0afa9f05e72015d27239b263447c5628432196025108a0'),
	('includes/lock.inc','a181c8bd4f88d292a0a73b9f1fbd727e3314f66ec3631f288e6b9a54ba2b70fa'),
	('includes/mail.inc','d9fb2b99025745cbb73ebcfc7ac12df100508b9273ce35c433deacf12dd6a13a'),
	('includes/menu.inc','0ef3f1eaf959e8ac2f5a398c63af0b3f6434693bbb2b845e28156ed561238429'),
	('includes/module.inc','dc33027e05640be98906147e3dac86856841de8a45a754194b664e3a67721d05'),
	('includes/pager.inc','6f9494b85c07a2cc3be4e54aff2d2757485238c476a7da084d25bde1d88be6d8'),
	('includes/password.inc','fd9a1c94fe5a0fa7c7049a2435c7280b1d666b2074595010e3c492dd15712775'),
	('includes/path.inc','74bf05f3c68b0218730abf3e539fcf08b271959c8f4611940d05124f34a6a66f'),
	('includes/registry.inc','c225de772f86eebd21b0b52fa8fcc6671e05fa2374cedb3164f7397f27d3c88d'),
	('includes/session.inc','7548621ae4c273179a76eba41aa58b740100613bc015ad388a5c30132b61e34b'),
	('includes/stream_wrappers.inc','4f1feb774a8dbc04ca382fa052f59e58039c7261625f3df29987d6b31f08d92d'),
	('includes/tablesort.inc','2d88768a544829595dd6cda2a5eb008bedb730f36bba6dfe005d9ddd999d5c0f'),
	('includes/theme.inc','904076056d8cd49042d6c1faefbd7f8ec40469143a2a22ae2c36a2ecf54444c6'),
	('includes/theme.maintenance.inc','39f068b3eee4d10a90d6aa3c86db587b6d25844c2919d418d34d133cfe330f5a'),
	('includes/token.inc','5e7898cd78689e2c291ed3cd8f41c032075656896f1db57e49217aac19ae0428'),
	('includes/unicode.entities.inc','2b858138596d961fbaa4c6e3986e409921df7f76b6ee1b109c4af5970f1e0f54'),
	('includes/unicode.inc','e18772dafe0f80eb139fcfc582fef1704ba9f730647057d4f4841d6a6e4066ca'),
	('includes/update.inc','177ce24362efc7f28b384c90a09c3e485396bbd18c3721d4b21e57dd1733bd92'),
	('includes/updater.inc','d2da0e74ed86e93c209f16069f3d32e1a134ceb6c06a0044f78e841a1b54e380'),
	('includes/utility.inc','3458fd2b55ab004dd0cc529b8e58af12916e8bd36653b072bdd820b26b907ed5'),
	('includes/xmlrpc.inc','ea24176ec445c440ba0c825fc7b04a31b440288df8ef02081560dc418e34e659'),
	('includes/xmlrpcs.inc','741aa8d6fcc6c45a9409064f52351f7999b7c702d73def8da44de2567946598a'),
	('modules/block/block.test','40d9de00589211770a85c47d38c8ad61c598ec65d9332128a882eb8750e65a16'),
	('modules/color/color.test','013806279bd47ceb2f82ca854b57f880ba21058f7a2592c422afae881a7f5d15'),
	('modules/comment/comment.module','db858137ff6ce06d87cb3b8f5275bed90c33a6d9aa7d46e7a74524cc2f052309'),
	('modules/comment/comment.test','0443a4dbc5aef3d64405a7cabf462c8c5e0b24517d89410d261027b85292cd4b'),
	('modules/contextual/contextual.test','023dafa199bd325ecc55a17b2a3db46ac0a31e23059f701f789f3bc42427ba0b'),
	('modules/dashboard/dashboard.test','125df00fc6deb985dc554aa7807a48e60a68dbbddbad9ec2c4718da724f0e683'),
	('modules/dblog/dblog.test','11fbb8522b1c9dc7c85edba3aed7308a8891f26fc7292008822bea1b54722912'),
	('modules/field/field.attach.inc','2df4687b5ec078c4893dc1fea514f67524fd5293de717b9e05caf977e5ae2327'),
	('modules/field/field.info.class.inc','a6f2f418552dba0e03f57ee812a6f0f63bbfe4bf81fe805d51ecec47ef84b845'),
	('modules/field/field.module','e9359f8cac64b2d81ac067d7da22972116dc10b9b346752a8ef8292943a958c9'),
	('modules/field/modules/field_sql_storage/field_sql_storage.test','315eedaf2022afc884c35efd3b7c400eddab6ea30bec91924bc82ab5cd3e79f2'),
	('modules/field/modules/list/tests/list.test','97e55bd49f6f4b0562d04aa3773b5ab9b35063aee05c8c7231780cdcf9c97714'),
	('modules/field/modules/number/number.test','9ccf835bbf80ff31b121286f6fbcf59cc42b622a51ab56b22362b2f55c656e18'),
	('modules/field/modules/options/options.test','c71441020206b1587dece7296cca306a9f0fbd6e8f04dae272efc15ed3a38383'),
	('modules/field/modules/text/text.test','a1e5cb0fa8c0651c68d560d9bb7781463a84200f701b00b6e797a9ca792a7e42'),
	('modules/field/tests/field.test','5eaad7a933ef8ea05b958056492ce17858cd542111f0fe81dd1a5949ad8f966e'),
	('modules/field_ui/field_ui.test','da42e28d6f32d447b4a6e5b463a2f7d87d6ce32f149de04a98fa8e3f286c9f68'),
	('modules/file/tests/file.test','055d10e7817d5c3dfee1039af4205b20d37bbaf5745481a7cf45d5f89f17f51b'),
	('modules/filter/filter.test','6e5dde973a2ac613049ff524991cba1fab9765e7292876301f7ef10c674caa3f'),
	('modules/help/help.test','bc934de8c71bd9874a05ccb5e8f927f4c227b3b2397d739e8504c8fd6ae5a83c'),
	('modules/image/image.test','628eb9ff10eb39cd37814cba6c7f93d2b63b299937f3029f7669929fe96bd467'),
	('modules/menu/menu.test','cd187c84aa97dcc228d8a1556ea10640c62f86083034533b6ac6830be610ca2a'),
	('modules/node/node.module','fbf1324ab7758c3f13de922a3094c5579747f9a98da248ff19c391880abc958b'),
	('modules/node/node.test','e2e485fde00796305fd6926c8b4e9c4e1919020a3ec00819aa5cc1d2b3ebcc5c'),
	('modules/path/path.test','2004183b2c7c86028bf78c519c6a7afc4397a8267874462b0c2b49b0f8c20322'),
	('modules/rdf/rdf.test','9849d2b717119aa6b5f1496929e7ac7c9c0a6e98486b66f3876bda0a8c165525'),
	('modules/search/search.extender.inc','d754e360bba0e997c7894faeea004c8fb0c6bf1c4ce909f87c7c2f619da602ad'),
	('modules/search/search.test','da5b704c07a540fb53600a65aa9ff5e98afa5cb1fca5556531f8f0d672edffbd'),
	('modules/shortcut/shortcut.test','0d78280d4d0a05aa772218e45911552e39611ca9c258b9dd436307914ac3f254'),
	('modules/system/system.archiver.inc','faa849f3e646a910ab82fd6c8bbf0a4e6b8c60725d7ba81ec0556bd716616cd1'),
	('modules/system/system.mail.inc','d31e1769f5defbe5f27dc68f641ab80fb8d3de92f6e895f4c654ec05fc7e5f0f'),
	('modules/system/system.queue.inc','a60cff401fc410cd81dc1d105ed66f79396ed7b15fdc3a5c5b80593ad5d4352a'),
	('modules/system/system.tar.inc','8a31d91f7b3cd7eac25b3fa46e1ed9a8527c39718ba76c3f8c0bbbeaa3aa4086'),
	('modules/system/system.test','0578e0b93202615c5f0a9971fded42bb0ba4db5fa037ded0846e7fa4f65e9d07'),
	('modules/system/system.updater.inc','338cf14cb691ba16ee551b3b9e0fa4f579a2f25c964130658236726d17563b6a'),
	('modules/taxonomy/taxonomy.module','45d6d5652a464318f3eccf8bad6220cc5784e7ffdb0c7b732bf4d540e1effe83'),
	('modules/taxonomy/taxonomy.test','8525035816906e327ad48bd48bb071597f4c58368a692bcec401299a86699e6e'),
	('modules/user/user.module','ba99da1da371b6c4cc39f2f5523a350d33b710930ef734f33cf54f074fa5a399'),
	('modules/user/user.test','3ddbe3ec49425cb4eac7321f682d7734a5e008af2f7c6e9f4815ae948a94e8f5');

/*!40000 ALTER TABLE `registry_file` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `role`;

CREATE TABLE `role` (
  `rid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique role ID.',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT 'Unique role name.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this role in listings and the user interface.',
  PRIMARY KEY (`rid`),
  UNIQUE KEY `name` (`name`),
  KEY `name_weight` (`name`,`weight`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores user roles.';

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;

INSERT INTO `role` (`rid`, `name`, `weight`)
VALUES
	(3,'administrator',2),
	(1,'anonymous user',0),
	(2,'authenticated user',1);

/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table role_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `role_permission`;

CREATE TABLE `role_permission` (
  `rid` int(10) unsigned NOT NULL COMMENT 'Foreign Key: role.rid.',
  `permission` varchar(128) NOT NULL DEFAULT '' COMMENT 'A single permission granted to the role identified by rid.',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The module declaring the permission.',
  PRIMARY KEY (`rid`,`permission`),
  KEY `permission` (`permission`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores the permissions assigned to user roles.';

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;

INSERT INTO `role_permission` (`rid`, `permission`, `module`)
VALUES
	(1,'access comments','comment'),
	(1,'access content','node'),
	(1,'use text format filtered_html','filter'),
	(2,'access comments','comment'),
	(2,'access content','node'),
	(2,'post comments','comment'),
	(2,'skip comment approval','comment'),
	(2,'use text format filtered_html','filter'),
	(3,'access administration pages','system'),
	(3,'access comments','comment'),
	(3,'access content','node'),
	(3,'access content overview','node'),
	(3,'access contextual links','contextual'),
	(3,'access dashboard','dashboard'),
	(3,'access overlay','overlay'),
	(3,'access site in maintenance mode','system'),
	(3,'access site reports','system'),
	(3,'access toolbar','toolbar'),
	(3,'access user profiles','user'),
	(3,'administer actions','system'),
	(3,'administer blocks','block'),
	(3,'administer comments','comment'),
	(3,'administer content types','node'),
	(3,'administer filters','filter'),
	(3,'administer image styles','image'),
	(3,'administer menu','menu'),
	(3,'administer modules','system'),
	(3,'administer nodes','node'),
	(3,'administer permissions','user'),
	(3,'administer search','search'),
	(3,'administer shortcuts','shortcut'),
	(3,'administer site configuration','system'),
	(3,'administer software updates','system'),
	(3,'administer taxonomy','taxonomy'),
	(3,'administer themes','system'),
	(3,'administer url aliases','path'),
	(3,'administer users','user'),
	(3,'block IP addresses','system'),
	(3,'bypass node access','node'),
	(3,'cancel account','user'),
	(3,'change own username','user'),
	(3,'create article content','node'),
	(3,'create page content','node'),
	(3,'create url aliases','path'),
	(3,'customize shortcut links','shortcut'),
	(3,'delete any article content','node'),
	(3,'delete any page content','node'),
	(3,'delete own article content','node'),
	(3,'delete own page content','node'),
	(3,'delete revisions','node'),
	(3,'delete terms in 1','taxonomy'),
	(3,'edit any article content','node'),
	(3,'edit any page content','node'),
	(3,'edit own article content','node'),
	(3,'edit own comments','comment'),
	(3,'edit own page content','node'),
	(3,'edit terms in 1','taxonomy'),
	(3,'post comments','comment'),
	(3,'revert revisions','node'),
	(3,'search content','search'),
	(3,'select account cancellation method','user'),
	(3,'skip comment approval','comment'),
	(3,'switch shortcut sets','shortcut'),
	(3,'use advanced search','search'),
	(3,'use text format filtered_html','filter'),
	(3,'use text format full_html','filter'),
	(3,'view own unpublished content','node'),
	(3,'view revisions','node'),
	(3,'view the administration theme','system');

/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table search_dataset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `search_dataset`;

CREATE TABLE `search_dataset` (
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Search item ID, e.g. node ID for nodes.',
  `type` varchar(16) NOT NULL COMMENT 'Type of item, e.g. node.',
  `data` longtext NOT NULL COMMENT 'List of space-separated words from the item.',
  `reindex` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Set to force node reindexing.',
  PRIMARY KEY (`sid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores items that will be searched.';



# Dump of table search_index
# ------------------------------------------------------------

DROP TABLE IF EXISTS `search_index`;

CREATE TABLE `search_index` (
  `word` varchar(50) NOT NULL DEFAULT '' COMMENT 'The search_total.word that is associated with the search item.',
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The search_dataset.sid of the searchable item to which the word belongs.',
  `type` varchar(16) NOT NULL COMMENT 'The search_dataset.type of the searchable item to which the word belongs.',
  `score` float DEFAULT NULL COMMENT 'The numeric score of the word, higher being more important.',
  PRIMARY KEY (`word`,`sid`,`type`),
  KEY `sid_type` (`sid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores the search index, associating words, items and...';



# Dump of table search_node_links
# ------------------------------------------------------------

DROP TABLE IF EXISTS `search_node_links`;

CREATE TABLE `search_node_links` (
  `sid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The search_dataset.sid of the searchable item containing the link to the node.',
  `type` varchar(16) NOT NULL DEFAULT '' COMMENT 'The search_dataset.type of the searchable item containing the link to the node.',
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid that this item links to.',
  `caption` longtext COMMENT 'The text used to link to the node.nid.',
  PRIMARY KEY (`sid`,`type`,`nid`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores items (like nodes) that link to other nodes, used...';



# Dump of table search_total
# ------------------------------------------------------------

DROP TABLE IF EXISTS `search_total`;

CREATE TABLE `search_total` (
  `word` varchar(50) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique word in the search index.',
  `count` float DEFAULT NULL COMMENT 'The count of the word in the index using Zipf’s law to equalize the probability distribution.',
  PRIMARY KEY (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores search totals for words.';



# Dump of table semaphore
# ------------------------------------------------------------

DROP TABLE IF EXISTS `semaphore`;

CREATE TABLE `semaphore` (
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Primary Key: Unique name.',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT 'A value for the semaphore.',
  `expire` double NOT NULL COMMENT 'A Unix timestamp with microseconds indicating when the semaphore should expire.',
  PRIMARY KEY (`name`),
  KEY `value` (`value`),
  KEY `expire` (`expire`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table for holding semaphores, locks, flags, etc. that...';



# Dump of table sequences
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sequences`;

CREATE TABLE `sequences` (
  `value` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The value of the sequence.',
  PRIMARY KEY (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores IDs.';

LOCK TABLES `sequences` WRITE;
/*!40000 ALTER TABLE `sequences` DISABLE KEYS */;

INSERT INTO `sequences` (`value`)
VALUES
	(1);

/*!40000 ALTER TABLE `sequences` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sessions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `uid` int(10) unsigned NOT NULL COMMENT 'The users.uid corresponding to a session, or 0 for anonymous user.',
  `sid` varchar(128) NOT NULL COMMENT 'A session ID. The value is generated by Drupal’s session handlers.',
  `ssid` varchar(128) NOT NULL DEFAULT '' COMMENT 'Secure session ID. The value is generated by Drupal’s session handlers.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'The IP address that last used this session ID (sid).',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when this session last requested a page. Old records are purged by PHP automatically.',
  `cache` int(11) NOT NULL DEFAULT '0' COMMENT 'The time of this user’s last post. This is used when the site has specified a minimum_cache_lifetime. See cache_get().',
  `session` longblob COMMENT 'The serialized contents of $_SESSION, an array of name/value pairs that persists across page requests by this session ID. Drupal loads $_SESSION from here at the start of each request and saves it at the end.',
  PRIMARY KEY (`sid`,`ssid`),
  KEY `timestamp` (`timestamp`),
  KEY `uid` (`uid`),
  KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Drupal’s session handlers read and write into the...';



# Dump of table shortcut_set
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shortcut_set`;

CREATE TABLE `shortcut_set` (
  `set_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'Primary Key: The menu_links.menu_name under which the set’s links are stored.',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'The title of the set.',
  PRIMARY KEY (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores information about sets of shortcuts links.';

LOCK TABLES `shortcut_set` WRITE;
/*!40000 ALTER TABLE `shortcut_set` DISABLE KEYS */;

INSERT INTO `shortcut_set` (`set_name`, `title`)
VALUES
	('shortcut-set-1','Default');

/*!40000 ALTER TABLE `shortcut_set` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table shortcut_set_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `shortcut_set_users`;

CREATE TABLE `shortcut_set_users` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The users.uid for this set.',
  `set_name` varchar(32) NOT NULL DEFAULT '' COMMENT 'The shortcut_set.set_name that will be displayed for this user.',
  PRIMARY KEY (`uid`),
  KEY `set_name` (`set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps users to shortcut sets.';



# Dump of table system
# ------------------------------------------------------------

DROP TABLE IF EXISTS `system`;

CREATE TABLE `system` (
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT 'The path of the primary file for this item, relative to the Drupal root; e.g. modules/node/node.module.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The name of the item; e.g. node.',
  `type` varchar(12) NOT NULL DEFAULT '' COMMENT 'The type of the item, either module, theme, or theme_engine.',
  `owner` varchar(255) NOT NULL DEFAULT '' COMMENT 'A theme’s ’parent’ . Can be either a theme or an engine.',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether or not this item is enabled.',
  `bootstrap` int(11) NOT NULL DEFAULT '0' COMMENT 'Boolean indicating whether this module is loaded during Drupal’s early bootstrapping phase (e.g. even before the page cache is consulted).',
  `schema_version` smallint(6) NOT NULL DEFAULT '-1' COMMENT 'The module’s database schema version number. -1 if the module is not installed (its tables do not exist); 0 or the largest N of the module’s hook_update_N() function that has either been run or existed when the module was first installed.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The order in which this module’s hooks should be invoked relative to other modules. Equal-weighted modules are ordered by name.',
  `info` blob COMMENT 'A serialized array containing information from the module’s .info file; keys can include name, description, package, version, core, dependencies, and php.',
  PRIMARY KEY (`filename`),
  KEY `system_list` (`status`,`bootstrap`,`type`,`weight`,`name`),
  KEY `type_name` (`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A list of all modules, themes, and theme engines that are...';

LOCK TABLES `system` WRITE;
/*!40000 ALTER TABLE `system` DISABLE KEYS */;

INSERT INTO `system` (`filename`, `name`, `type`, `owner`, `status`, `bootstrap`, `schema_version`, `weight`, `info`)
VALUES
	('modules/aggregator/aggregator.module','aggregator','module','',0,0,-1,0,X'613A31343A7B733A343A226E616D65223B733A31303A2241676772656761746F72223B733A31313A226465736372697074696F6E223B733A35373A22416767726567617465732073796E6469636174656420636F6E74656E7420285253532C205244462C20616E642041746F6D206665656473292E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31353A2261676772656761746F722E74657374223B7D733A393A22636F6E666967757265223B733A34313A2261646D696E2F636F6E6669672F73657276696365732F61676772656761746F722F73657474696E6773223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31343A2261676772656761746F722E637373223B733A33333A226D6F64756C65732F61676772656761746F722F61676772656761746F722E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/aggregator/tests/aggregator_test.module','aggregator_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32333A2241676772656761746F72206D6F64756C65207465737473223B733A31313A226465736372697074696F6E223B733A34363A22537570706F7274206D6F64756C6520666F722061676772656761746F722072656C617465642074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/block/block.module','block','module','',1,0,7009,-5,X'613A31333A7B733A343A226E616D65223B733A353A22426C6F636B223B733A31313A226465736372697074696F6E223B733A3134303A22436F6E74726F6C73207468652076697375616C206275696C64696E6720626C6F636B732061207061676520697320636F6E737472756374656420776974682E20426C6F636B732061726520626F786573206F6620636F6E74656E742072656E646572656420696E746F20616E20617265612C206F7220726567696F6E2C206F6620612077656220706167652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31303A22626C6F636B2E74657374223B7D733A393A22636F6E666967757265223B733A32313A2261646D696E2F7374727563747572652F626C6F636B223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/block/tests/block_test.module','block_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A22426C6F636B2074657374223B733A31313A226465736372697074696F6E223B733A32313A2250726F7669646573207465737420626C6F636B732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/blog/blog.module','blog','module','',0,0,-1,0,X'613A31323A7B733A343A226E616D65223B733A343A22426C6F67223B733A31313A226465736372697074696F6E223B733A32353A22456E61626C6573206D756C74692D7573657220626C6F67732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A22626C6F672E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/book/book.module','book','module','',0,0,-1,0,X'613A31343A7B733A343A226E616D65223B733A343A22426F6F6B223B733A31313A226465736372697074696F6E223B733A36363A22416C6C6F777320757365727320746F2063726561746520616E64206F7267616E697A652072656C6174656420636F6E74656E7420696E20616E206F75746C696E652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A22626F6F6B2E74657374223B7D733A393A22636F6E666967757265223B733A32373A2261646D696E2F636F6E74656E742F626F6F6B2F73657474696E6773223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A383A22626F6F6B2E637373223B733A32313A226D6F64756C65732F626F6F6B2F626F6F6B2E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/color/color.module','color','module','',1,0,7001,0,X'613A31323A7B733A343A226E616D65223B733A353A22436F6C6F72223B733A31313A226465736372697074696F6E223B733A37303A22416C6C6F77732061646D696E6973747261746F727320746F206368616E67652074686520636F6C6F7220736368656D65206F6620636F6D70617469626C65207468656D65732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31303A22636F6C6F722E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/comment/comment.module','comment','module','',1,0,7009,0,X'613A31343A7B733A343A226E616D65223B733A373A22436F6D6D656E74223B733A31313A226465736372697074696F6E223B733A35373A22416C6C6F777320757365727320746F20636F6D6D656E74206F6E20616E642064697363757373207075626C697368656420636F6E74656E742E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A343A2274657874223B7D733A353A2266696C6573223B613A323A7B693A303B733A31343A22636F6D6D656E742E6D6F64756C65223B693A313B733A31323A22636F6D6D656E742E74657374223B7D733A393A22636F6E666967757265223B733A32313A2261646D696E2F636F6E74656E742F636F6D6D656E74223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31313A22636F6D6D656E742E637373223B733A32373A226D6F64756C65732F636F6D6D656E742F636F6D6D656E742E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/contact/contact.module','contact','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A373A22436F6E74616374223B733A31313A226465736372697074696F6E223B733A36313A22456E61626C65732074686520757365206F6620626F746820706572736F6E616C20616E6420736974652D7769646520636F6E7461637420666F726D732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31323A22636F6E746163742E74657374223B7D733A393A22636F6E666967757265223B733A32333A2261646D696E2F7374727563747572652F636F6E74616374223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/contextual/contextual.module','contextual','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A31363A22436F6E7465787475616C206C696E6B73223B733A31313A226465736372697074696F6E223B733A37353A2250726F766964657320636F6E7465787475616C206C696E6B7320746F20706572666F726D20616374696F6E732072656C6174656420746F20656C656D656E7473206F6E206120706167652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31353A22636F6E7465787475616C2E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/dashboard/dashboard.module','dashboard','module','',1,0,0,0,X'613A31333A7B733A343A226E616D65223B733A393A2244617368626F617264223B733A31313A226465736372697074696F6E223B733A3133363A2250726F766964657320612064617368626F617264207061676520696E207468652061646D696E69737472617469766520696E7465726661636520666F72206F7267616E697A696E672061646D696E697374726174697665207461736B7320616E6420747261636B696E6720696E666F726D6174696F6E2077697468696E20796F757220736974652E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A353A2266696C6573223B613A313A7B693A303B733A31343A2264617368626F6172642E74657374223B7D733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A22626C6F636B223B7D733A393A22636F6E666967757265223B733A32353A2261646D696E2F64617368626F6172642F637573746F6D697A65223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/dblog/dblog.module','dblog','module','',1,1,7002,0,X'613A31323A7B733A343A226E616D65223B733A31363A224461746162617365206C6F6767696E67223B733A31313A226465736372697074696F6E223B733A34373A224C6F677320616E64207265636F7264732073797374656D206576656E747320746F207468652064617461626173652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31303A2264626C6F672E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/field.module','field','module','',1,0,7003,0,X'613A31343A7B733A343A226E616D65223B733A353A224669656C64223B733A31313A226465736372697074696F6E223B733A35373A224669656C642041504920746F20616464206669656C647320746F20656E746974696573206C696B65206E6F64657320616E642075736572732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A343A7B693A303B733A31323A226669656C642E6D6F64756C65223B693A313B733A31363A226669656C642E6174746163682E696E63223B693A323B733A32303A226669656C642E696E666F2E636C6173732E696E63223B693A333B733A31363A2274657374732F6669656C642E74657374223B7D733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A31373A226669656C645F73716C5F73746F72616765223B7D733A383A227265717569726564223B623A313B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31353A227468656D652F6669656C642E637373223B733A32393A226D6F64756C65732F6669656C642F7468656D652F6669656C642E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/field_sql_storage/field_sql_storage.module','field_sql_storage','module','',1,0,7002,0,X'613A31333A7B733A343A226E616D65223B733A31373A224669656C642053514C2073746F72616765223B733A31313A226465736372697074696F6E223B733A33373A2253746F726573206669656C64206461746120696E20616E2053514C2064617461626173652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A32323A226669656C645F73716C5F73746F726167652E74657374223B7D733A383A227265717569726564223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/list/list.module','list','module','',1,0,7002,0,X'613A31323A7B733A343A226E616D65223B733A343A224C697374223B733A31313A226465736372697074696F6E223B733A36393A22446566696E6573206C697374206669656C642074797065732E205573652077697468204F7074696F6E7320746F206372656174652073656C656374696F6E206C697374732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A323A7B693A303B733A353A226669656C64223B693A313B733A373A226F7074696F6E73223B7D733A353A2266696C6573223B613A313A7B693A303B733A31353A2274657374732F6C6973742E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/list/tests/list_test.module','list_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A393A224C6973742074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220746865204C697374206D6F64756C652074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/number/number.module','number','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A363A224E756D626572223B733A31313A226465736372697074696F6E223B733A32383A22446566696E6573206E756D65726963206669656C642074797065732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A31313A226E756D6265722E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/options/options.module','options','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A373A224F7074696F6E73223B733A31313A226465736372697074696F6E223B733A38323A22446566696E65732073656C656374696F6E2C20636865636B20626F7820616E6420726164696F20627574746F6E207769646765747320666F72207465787420616E64206E756D65726963206669656C64732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A31323A226F7074696F6E732E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/modules/text/text.module','text','module','',1,0,7000,0,X'613A31333A7B733A343A226E616D65223B733A343A2254657874223B733A31313A226465736372697074696F6E223B733A33323A22446566696E65732073696D706C652074657874206669656C642074797065732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A393A22746578742E74657374223B7D733A383A227265717569726564223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field/tests/field_test.module','field_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31343A224669656C64204150492054657374223B733A31313A226465736372697074696F6E223B733A33393A22537570706F7274206D6F64756C6520666F7220746865204669656C64204150492074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A353A2266696C6573223B613A313A7B693A303B733A32313A226669656C645F746573742E656E746974792E696E63223B7D733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/field_ui/field_ui.module','field_ui','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A383A224669656C64205549223B733A31313A226465736372697074696F6E223B733A33333A225573657220696E7465726661636520666F7220746865204669656C64204150492E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A31333A226669656C645F75692E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/file/file.module','file','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A343A2246696C65223B733A31313A226465736372697074696F6E223B733A32363A22446566696E657320612066696C65206669656C6420747970652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A353A226669656C64223B7D733A353A2266696C6573223B613A313A7B693A303B733A31353A2274657374732F66696C652E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/file/tests/file_module_test.module','file_module_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A393A2246696C652074657374223B733A31313A226465736372697074696F6E223B733A35333A2250726F766964657320686F6F6B7320666F722074657374696E672046696C65206D6F64756C652066756E6374696F6E616C6974792E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/filter/filter.module','filter','module','',1,0,7010,0,X'613A31343A7B733A343A226E616D65223B733A363A2246696C746572223B733A31313A226465736372697074696F6E223B733A34333A2246696C7465727320636F6E74656E7420696E207072657061726174696F6E20666F7220646973706C61792E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31313A2266696C7465722E74657374223B7D733A383A227265717569726564223B623A313B733A393A22636F6E666967757265223B733A32383A2261646D696E2F636F6E6669672F636F6E74656E742F666F726D617473223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/forum/forum.module','forum','module','',0,0,-1,0,X'613A31343A7B733A343A226E616D65223B733A353A22466F72756D223B733A31313A226465736372697074696F6E223B733A32373A2250726F76696465732064697363757373696F6E20666F72756D732E223B733A31323A22646570656E64656E63696573223B613A323A7B693A303B733A383A227461786F6E6F6D79223B693A313B733A373A22636F6D6D656E74223B7D733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31303A22666F72756D2E74657374223B7D733A393A22636F6E666967757265223B733A32313A2261646D696E2F7374727563747572652F666F72756D223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A393A22666F72756D2E637373223B733A32333A226D6F64756C65732F666F72756D2F666F72756D2E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/help/help.module','help','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A343A2248656C70223B733A31313A226465736372697074696F6E223B733A33353A224D616E616765732074686520646973706C6179206F66206F6E6C696E652068656C702E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A2268656C702E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/image/image.module','image','module','',1,0,7005,0,X'613A31333A7B733A343A226E616D65223B733A353A22496D616765223B733A31313A226465736372697074696F6E223B733A33343A2250726F766964657320696D616765206D616E6970756C6174696F6E20746F6F6C732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A343A2266696C65223B7D733A353A2266696C6573223B613A313A7B693A303B733A31303A22696D6167652E74657374223B7D733A393A22636F6E666967757265223B733A33313A2261646D696E2F636F6E6669672F6D656469612F696D6167652D7374796C6573223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/image/tests/image_module_test.module','image_module_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A22496D6167652074657374223B733A31313A226465736372697074696F6E223B733A36393A2250726F766964657320686F6F6B20696D706C656D656E746174696F6E7320666F722074657374696E6720496D616765206D6F64756C652066756E6374696F6E616C6974792E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A32343A22696D6167655F6D6F64756C655F746573742E6D6F64756C65223B7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/locale/locale.module','locale','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A363A224C6F63616C65223B733A31313A226465736372697074696F6E223B733A3131393A2241646473206C616E67756167652068616E646C696E672066756E6374696F6E616C69747920616E6420656E61626C657320746865207472616E736C6174696F6E206F6620746865207573657220696E7465726661636520746F206C616E677561676573206F74686572207468616E20456E676C6973682E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31313A226C6F63616C652E74657374223B7D733A393A22636F6E666967757265223B733A33303A2261646D696E2F636F6E6669672F726567696F6E616C2F6C616E6775616765223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/locale/tests/locale_test.module','locale_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A224C6F63616C652054657374223B733A31313A226465736372697074696F6E223B733A34323A22537570706F7274206D6F64756C6520666F7220746865206C6F63616C65206C617965722074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/menu/menu.module','menu','module','',1,0,7003,0,X'613A31333A7B733A343A226E616D65223B733A343A224D656E75223B733A31313A226465736372697074696F6E223B733A36303A22416C6C6F77732061646D696E6973747261746F727320746F20637573746F6D697A65207468652073697465206E617669676174696F6E206D656E752E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A226D656E752E74657374223B7D733A393A22636F6E666967757265223B733A32303A2261646D696E2F7374727563747572652F6D656E75223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/node/node.module','node','module','',1,0,7015,0,X'613A31353A7B733A343A226E616D65223B733A343A224E6F6465223B733A31313A226465736372697074696F6E223B733A36363A22416C6C6F777320636F6E74656E7420746F206265207375626D697474656420746F20746865207369746520616E6420646973706C61796564206F6E2070616765732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A323A7B693A303B733A31313A226E6F64652E6D6F64756C65223B693A313B733A393A226E6F64652E74657374223B7D733A383A227265717569726564223B623A313B733A393A22636F6E666967757265223B733A32313A2261646D696E2F7374727563747572652F7479706573223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A383A226E6F64652E637373223B733A32313A226D6F64756C65732F6E6F64652F6E6F64652E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/node/tests/node_access_test.module','node_access_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32343A224E6F6465206D6F64756C6520616363657373207465737473223B733A31313A226465736372697074696F6E223B733A34333A22537570706F7274206D6F64756C6520666F72206E6F6465207065726D697373696F6E2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/node/tests/node_test.module','node_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31373A224E6F6465206D6F64756C65207465737473223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F72206E6F64652072656C617465642074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/node/tests/node_test_exception.module','node_test_exception','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32373A224E6F6465206D6F64756C6520657863657074696F6E207465737473223B733A31313A226465736372697074696F6E223B733A35303A22537570706F7274206D6F64756C6520666F72206E6F64652072656C6174656420657863657074696F6E2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/openid/openid.module','openid','module','',0,0,-1,0,X'613A31323A7B733A343A226E616D65223B733A363A224F70656E4944223B733A31313A226465736372697074696F6E223B733A34383A22416C6C6F777320757365727320746F206C6F6720696E746F20796F75722073697465207573696E67204F70656E49442E223B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A227061636B616765223B733A343A22436F7265223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31313A226F70656E69642E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/openid/tests/openid_test.module','openid_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32313A224F70656E49442064756D6D792070726F7669646572223B733A31313A226465736372697074696F6E223B733A33333A224F70656E49442070726F7669646572207573656420666F722074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A363A226F70656E6964223B7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/overlay/overlay.module','overlay','module','',1,1,0,0,X'613A31323A7B733A343A226E616D65223B733A373A224F7665726C6179223B733A31313A226465736372697074696F6E223B733A35393A22446973706C617973207468652044727570616C2061646D696E697374726174696F6E20696E7465726661636520696E20616E206F7665726C61792E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/path/path.module','path','module','',1,0,0,0,X'613A31333A7B733A343A226E616D65223B733A343A2250617468223B733A31313A226465736372697074696F6E223B733A32383A22416C6C6F777320757365727320746F2072656E616D652055524C732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A22706174682E74657374223B7D733A393A22636F6E666967757265223B733A32343A2261646D696E2F636F6E6669672F7365617263682F70617468223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/php/php.module','php','module','',0,0,-1,0,X'613A31323A7B733A343A226E616D65223B733A31303A225048502066696C746572223B733A31313A226465736372697074696F6E223B733A35303A22416C6C6F777320656D6265646465642050485020636F64652F736E69707065747320746F206265206576616C75617465642E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A383A227068702E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/poll/poll.module','poll','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A343A22506F6C6C223B733A31313A226465736372697074696F6E223B733A39353A22416C6C6F777320796F7572207369746520746F206361707475726520766F746573206F6E20646966666572656E7420746F7069637320696E2074686520666F726D206F66206D756C7469706C652063686F696365207175657374696F6E732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A393A22706F6C6C2E74657374223B7D733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A383A22706F6C6C2E637373223B733A32313A226D6F64756C65732F706F6C6C2F706F6C6C2E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/profile/profile.module','profile','module','',0,0,-1,0,X'613A31343A7B733A343A226E616D65223B733A373A2250726F66696C65223B733A31313A226465736372697074696F6E223B733A33363A22537570706F72747320636F6E666967757261626C6520757365722070726F66696C65732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31323A2270726F66696C652E74657374223B7D733A393A22636F6E666967757265223B733A32373A2261646D696E2F636F6E6669672F70656F706C652F70726F66696C65223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/rdf/rdf.module','rdf','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A333A22524446223B733A31313A226465736372697074696F6E223B733A3134383A22456E72696368657320796F757220636F6E74656E742077697468206D6574616461746120746F206C6574206F74686572206170706C69636174696F6E732028652E672E2073656172636820656E67696E65732C2061676772656761746F7273292062657474657220756E6465727374616E64206974732072656C6174696F6E736869707320616E6420617474726962757465732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A383A227264662E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/rdf/tests/rdf_test.module','rdf_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31363A22524446206D6F64756C65207465737473223B733A31313A226465736372697074696F6E223B733A33383A22537570706F7274206D6F64756C6520666F7220524446206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/search/search.module','search','module','',1,0,7000,0,X'613A31343A7B733A343A226E616D65223B733A363A22536561726368223B733A31313A226465736372697074696F6E223B733A33363A22456E61626C657320736974652D77696465206B6579776F726420736561726368696E672E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A323A7B693A303B733A31393A227365617263682E657874656E6465722E696E63223B693A313B733A31313A227365617263682E74657374223B7D733A393A22636F6E666967757265223B733A32383A2261646D696E2F636F6E6669672F7365617263682F73657474696E6773223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A227365617263682E637373223B733A32353A226D6F64756C65732F7365617263682F7365617263682E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/search/tests/search_embedded_form.module','search_embedded_form','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32303A2253656172636820656D62656464656420666F726D223B733A31313A226465736372697074696F6E223B733A35393A22537570706F7274206D6F64756C6520666F7220736561726368206D6F64756C652074657374696E67206F6620656D62656464656420666F726D732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/search/tests/search_extra_type.module','search_extra_type','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31363A2254657374207365617263682074797065223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220736561726368206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/search/tests/search_node_tags.module','search_node_tags','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32313A225465737420736561726368206E6F64652074616773223B733A31313A226465736372697074696F6E223B733A34343A22537570706F7274206D6F64756C6520666F72204E6F64652073656172636820746167732074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/shortcut/shortcut.module','shortcut','module','',1,0,0,0,X'613A31333A7B733A343A226E616D65223B733A383A2253686F7274637574223B733A31313A226465736372697074696F6E223B733A36303A22416C6C6F777320757365727320746F206D616E61676520637573746F6D697A61626C65206C69737473206F662073686F7274637574206C696E6B732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31333A2273686F72746375742E74657374223B7D733A393A22636F6E666967757265223B733A33363A2261646D696E2F636F6E6669672F757365722D696E746572666163652F73686F7274637574223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/simpletest.module','simpletest','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A373A2254657374696E67223B733A31313A226465736372697074696F6E223B733A35333A2250726F76696465732061206672616D65776F726B20666F7220756E697420616E642066756E6374696F6E616C2074657374696E672E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A34393A7B693A303B733A31353A2273696D706C65746573742E74657374223B693A313B733A32343A2264727570616C5F7765625F746573745F636173652E706870223B693A323B733A31383A2274657374732F616374696F6E732E74657374223B693A333B733A31353A2274657374732F616A61782E74657374223B693A343B733A31363A2274657374732F62617463682E74657374223B693A353B733A32303A2274657374732F626F6F7473747261702E74657374223B693A363B733A31363A2274657374732F63616368652E74657374223B693A373B733A31373A2274657374732F636F6D6D6F6E2E74657374223B693A383B733A32343A2274657374732F64617461626173655F746573742E74657374223B693A393B733A32323A2274657374732F656E746974795F637275642E74657374223B693A31303B733A33323A2274657374732F656E746974795F637275645F686F6F6B5F746573742E74657374223B693A31313B733A32333A2274657374732F656E746974795F71756572792E74657374223B693A31323B733A31363A2274657374732F6572726F722E74657374223B693A31333B733A31353A2274657374732F66696C652E74657374223B693A31343B733A32333A2274657374732F66696C657472616E736665722E74657374223B693A31353B733A31353A2274657374732F666F726D2E74657374223B693A31363B733A31363A2274657374732F67726170682E74657374223B693A31373B733A31363A2274657374732F696D6167652E74657374223B693A31383B733A31353A2274657374732F6C6F636B2E74657374223B693A31393B733A31353A2274657374732F6D61696C2E74657374223B693A32303B733A31353A2274657374732F6D656E752E74657374223B693A32313B733A31373A2274657374732F6D6F64756C652E74657374223B693A32323B733A31363A2274657374732F70616765722E74657374223B693A32333B733A31393A2274657374732F70617373776F72642E74657374223B693A32343B733A31353A2274657374732F706174682E74657374223B693A32353B733A31393A2274657374732F72656769737472792E74657374223B693A32363B733A31373A2274657374732F736368656D612E74657374223B693A32373B733A31383A2274657374732F73657373696F6E2E74657374223B693A32383B733A32303A2274657374732F7461626C65736F72742E74657374223B693A32393B733A31363A2274657374732F7468656D652E74657374223B693A33303B733A31383A2274657374732F756E69636F64652E74657374223B693A33313B733A31373A2274657374732F7570646174652E74657374223B693A33323B733A31373A2274657374732F786D6C7270632E74657374223B693A33333B733A32363A2274657374732F757067726164652F757067726164652E74657374223B693A33343B733A33343A2274657374732F757067726164652F757067726164652E636F6D6D656E742E74657374223B693A33353B733A33333A2274657374732F757067726164652F757067726164652E66696C7465722E74657374223B693A33363B733A33323A2274657374732F757067726164652F757067726164652E666F72756D2E74657374223B693A33373B733A33333A2274657374732F757067726164652F757067726164652E6C6F63616C652E74657374223B693A33383B733A33313A2274657374732F757067726164652F757067726164652E6D656E752E74657374223B693A33393B733A33313A2274657374732F757067726164652F757067726164652E6E6F64652E74657374223B693A34303B733A33353A2274657374732F757067726164652F757067726164652E7461786F6E6F6D792E74657374223B693A34313B733A33343A2274657374732F757067726164652F757067726164652E747269676765722E74657374223B693A34323B733A33393A2274657374732F757067726164652F757067726164652E7472616E736C617461626C652E74657374223B693A34333B733A33333A2274657374732F757067726164652F757067726164652E75706C6F61642E74657374223B693A34343B733A33313A2274657374732F757067726164652F757067726164652E757365722E74657374223B693A34353B733A33363A2274657374732F757067726164652F7570646174652E61676772656761746F722E74657374223B693A34363B733A33333A2274657374732F757067726164652F7570646174652E747269676765722E74657374223B693A34373B733A33313A2274657374732F757067726164652F7570646174652E6669656C642E74657374223B693A34383B733A33303A2274657374732F757067726164652F7570646174652E757365722E74657374223B7D733A393A22636F6E666967757265223B733A34313A2261646D696E2F636F6E6669672F646576656C6F706D656E742F74657374696E672F73657474696E6773223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/actions_loop_test.module','actions_loop_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31373A22416374696F6E73206C6F6F702074657374223B733A31313A226465736372697074696F6E223B733A33393A22537570706F7274206D6F64756C6520666F7220616374696F6E206C6F6F702074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/ajax_forms_test.module','ajax_forms_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32363A22414A415820666F726D2074657374206D6F636B206D6F64756C65223B733A31313A226465736372697074696F6E223B733A32353A225465737420666F7220414A415820666F726D2063616C6C732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/ajax_test.module','ajax_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A393A22414A41582054657374223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F7220414A4158206672616D65776F726B2074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/batch_test.module','batch_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31343A224261746368204150492074657374223B733A31313A226465736372697074696F6E223B733A33353A22537570706F7274206D6F64756C6520666F72204261746368204150492074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/common_test.module','common_test','module','',0,0,-1,0,X'613A31343A7B733A343A226E616D65223B733A31313A22436F6D6D6F6E2054657374223B733A31313A226465736372697074696F6E223B733A33323A22537570706F7274206D6F64756C6520666F7220436F6D6D6F6E2074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A31353A22636F6D6D6F6E5F746573742E637373223B733A34303A226D6F64756C65732F73696D706C65746573742F74657374732F636F6D6D6F6E5F746573742E637373223B7D733A353A227072696E74223B613A313A7B733A32313A22636F6D6D6F6E5F746573742E7072696E742E637373223B733A34363A226D6F64756C65732F73696D706C65746573742F74657374732F636F6D6D6F6E5F746573742E7072696E742E637373223B7D7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/common_test_cron_helper.module','common_test_cron_helper','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32333A22436F6D6D6F6E20546573742043726F6E2048656C706572223B733A31313A226465736372697074696F6E223B733A35363A2248656C706572206D6F64756C6520666F722043726F6E52756E54657374436173653A3A7465737443726F6E457863657074696F6E7328292E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/database_test.module','database_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31333A2244617461626173652054657374223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F72204461746162617365206C617965722074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/drupal_autoload_test/drupal_autoload_test.module','drupal_autoload_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32353A2244727570616C20636F64652072656769737472792074657374223B733A31313A226465736372697074696F6E223B733A34353A22537570706F7274206D6F64756C6520666F722074657374696E672074686520636F64652072656769737472792E223B733A353A2266696C6573223B613A323A7B693A303B733A33343A2264727570616C5F6175746F6C6F61645F746573745F696E746572666163652E696E63223B693A313B733A33303A2264727570616C5F6175746F6C6F61645F746573745F636C6173732E696E63223B7D733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/drupal_system_listing_compatible_test/drupal_system_listing_compatible_test.module','drupal_system_listing_compatible_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A33373A2244727570616C2073797374656D206C697374696E6720636F6D70617469626C652074657374223B733A31313A226465736372697074696F6E223B733A36323A22537570706F7274206D6F64756C6520666F722074657374696E67207468652064727570616C5F73797374656D5F6C697374696E672066756E6374696F6E2E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/drupal_system_listing_incompatible_test/drupal_system_listing_incompatible_test.module','drupal_system_listing_incompatible_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A33393A2244727570616C2073797374656D206C697374696E6720696E636F6D70617469626C652074657374223B733A31313A226465736372697074696F6E223B733A36323A22537570706F7274206D6F64756C6520666F722074657374696E67207468652064727570616C5F73797374656D5F6C697374696E672066756E6374696F6E2E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/entity_cache_test.module','entity_cache_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31373A22456E746974792063616368652074657374223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F722074657374696E6720656E746974792063616368652E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A32383A22656E746974795F63616368655F746573745F646570656E64656E6379223B7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/entity_cache_test_dependency.module','entity_cache_test_dependency','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32383A22456E74697479206361636865207465737420646570656E64656E6379223B733A31313A226465736372697074696F6E223B733A35313A22537570706F727420646570656E64656E6379206D6F64756C6520666F722074657374696E6720656E746974792063616368652E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/entity_crud_hook_test.module','entity_crud_hook_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32323A22456E74697479204352554420486F6F6B732054657374223B733A31313A226465736372697074696F6E223B733A33353A22537570706F7274206D6F64756C6520666F72204352554420686F6F6B2074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/entity_query_access_test.module','entity_query_access_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32343A22456E74697479207175657279206163636573732074657374223B733A31313A226465736372697074696F6E223B733A34393A22537570706F7274206D6F64756C6520666F7220636865636B696E6720656E7469747920717565727920726573756C74732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/error_test.module','error_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A224572726F722074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F72206572726F7220616E6420657863657074696F6E2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/file_test.module','file_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A393A2246696C652074657374223B733A31313A226465736372697074696F6E223B733A33393A22537570706F7274206D6F64756C6520666F722066696C652068616E646C696E672074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31363A2266696C655F746573742E6D6F64756C65223B7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/filter_test.module','filter_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31383A2246696C7465722074657374206D6F64756C65223B733A31313A226465736372697074696F6E223B733A33333A2254657374732066696C74657220686F6F6B7320616E642066756E6374696F6E732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/form_test.module','form_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31323A22466F726D4150492054657374223B733A31313A226465736372697074696F6E223B733A33343A22537570706F7274206D6F64756C6520666F7220466F726D204150492074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/image_test.module','image_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A22496D6167652074657374223B733A31313A226465736372697074696F6E223B733A33393A22537570706F7274206D6F64756C6520666F7220696D61676520746F6F6C6B69742074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/menu_test.module','menu_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A22486F6F6B206D656E75207465737473223B733A31313A226465736372697074696F6E223B733A33373A22537570706F7274206D6F64756C6520666F72206D656E7520686F6F6B2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/module_test.module','module_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A224D6F64756C652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F72206D6F64756C652073797374656D2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/path_test.module','path_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A22486F6F6B2070617468207465737473223B733A31313A226465736372697074696F6E223B733A33373A22537570706F7274206D6F64756C6520666F72207061746820686F6F6B2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/psr_0_test/psr_0_test.module','psr_0_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31363A225053522D302054657374206361736573223B733A31313A226465736372697074696F6E223B733A34343A225465737420636C617373657320746F20626520646973636F76657265642062792073696D706C65746573742E223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/psr_4_test/psr_4_test.module','psr_4_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31363A225053522D342054657374206361736573223B733A31313A226465736372697074696F6E223B733A34343A225465737420636C617373657320746F20626520646973636F76657265642062792073696D706C65746573742E223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/requirements1_test.module','requirements1_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31393A22526571756972656D656E747320312054657374223B733A31313A226465736372697074696F6E223B733A38303A22546573747320746861742061206D6F64756C65206973206E6F7420696E7374616C6C6564207768656E206974206661696C7320686F6F6B5F726571756972656D656E74732827696E7374616C6C27292E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/requirements2_test.module','requirements2_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31393A22526571756972656D656E747320322054657374223B733A31313A226465736372697074696F6E223B733A39383A22546573747320746861742061206D6F64756C65206973206E6F7420696E7374616C6C6564207768656E20746865206F6E6520697420646570656E6473206F6E206661696C7320686F6F6B5F726571756972656D656E74732827696E7374616C6C292E223B733A31323A22646570656E64656E63696573223B613A323A7B693A303B733A31383A22726571756972656D656E7473315F74657374223B693A313B733A373A22636F6D6D656E74223B7D733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/session_test.module','session_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31323A2253657373696F6E2074657374223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F722073657373696F6E20646174612074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_dependencies_test.module','system_dependencies_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32323A2253797374656D20646570656E64656E63792074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F722074657374696E672073797374656D20646570656E64656E636965732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A31393A225F6D697373696E675F646570656E64656E6379223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_incompatible_core_version_dependencies_test.module','system_incompatible_core_version_dependencies_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A35303A2253797374656D20696E636F6D70617469626C6520636F72652076657273696F6E20646570656E64656E636965732074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F722074657374696E672073797374656D20646570656E64656E636965732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A33373A2273797374656D5F696E636F6D70617469626C655F636F72655F76657273696F6E5F74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_incompatible_core_version_test.module','system_incompatible_core_version_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A33373A2253797374656D20696E636F6D70617469626C6520636F72652076657273696F6E2074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F722074657374696E672073797374656D20646570656E64656E636965732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22352E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_incompatible_module_version_dependencies_test.module','system_incompatible_module_version_dependencies_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A35323A2253797374656D20696E636F6D70617469626C65206D6F64756C652076657273696F6E20646570656E64656E636965732074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F722074657374696E672073797374656D20646570656E64656E636965732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A34363A2273797374656D5F696E636F6D70617469626C655F6D6F64756C655F76657273696F6E5F7465737420283E322E3029223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_incompatible_module_version_test.module','system_incompatible_module_version_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A33393A2253797374656D20696E636F6D70617469626C65206D6F64756C652076657273696F6E2074657374223B733A31313A226465736372697074696F6E223B733A34373A22537570706F7274206D6F64756C6520666F722074657374696E672073797374656D20646570656E64656E636965732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/system_test.module','system_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A2253797374656D2074657374223B733A31313A226465736372697074696F6E223B733A33343A22537570706F7274206D6F64756C6520666F722073797374656D2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31383A2273797374656D5F746573742E6D6F64756C65223B7D733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/taxonomy_test.module','taxonomy_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32303A225461786F6E6F6D792074657374206D6F64756C65223B733A31313A226465736372697074696F6E223B733A34353A222254657374732066756E6374696F6E7320616E6420686F6F6B73206E6F74207573656420696E20636F7265222E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A383A227461786F6E6F6D79223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/theme_test.module','theme_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A225468656D652074657374223B733A31313A226465736372697074696F6E223B733A34303A22537570706F7274206D6F64756C6520666F72207468656D652073797374656D2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/update_script_test.module','update_script_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31383A22557064617465207363726970742074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220757064617465207363726970742074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/update_test_1.module','update_test_1','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A225570646174652074657374223B733A31313A226465736372697074696F6E223B733A33343A22537570706F7274206D6F64756C6520666F72207570646174652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/update_test_2.module','update_test_2','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A225570646174652074657374223B733A31313A226465736372697074696F6E223B733A33343A22537570706F7274206D6F64756C6520666F72207570646174652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/update_test_3.module','update_test_3','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A225570646174652074657374223B733A31313A226465736372697074696F6E223B733A33343A22537570706F7274206D6F64756C6520666F72207570646174652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/url_alter_test.module','url_alter_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A2255726C5F616C746572207465737473223B733A31313A226465736372697074696F6E223B733A34353A224120737570706F7274206D6F64756C657320666F722075726C5F616C74657220686F6F6B2074657374696E672E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/simpletest/tests/xmlrpc_test.module','xmlrpc_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31323A22584D4C2D5250432054657374223B733A31313A226465736372697074696F6E223B733A37353A22537570706F7274206D6F64756C6520666F7220584D4C2D525043207465737473206163636F7264696E6720746F207468652076616C696461746F72312073706563696669636174696F6E2E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/statistics/statistics.module','statistics','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31303A2253746174697374696373223B733A31313A226465736372697074696F6E223B733A33373A224C6F677320616363657373207374617469737469637320666F7220796F757220736974652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31353A22737461746973746963732E74657374223B7D733A393A22636F6E666967757265223B733A33303A2261646D696E2F636F6E6669672F73797374656D2F73746174697374696373223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/syslog/syslog.module','syslog','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A363A225379736C6F67223B733A31313A226465736372697074696F6E223B733A34313A224C6F677320616E64207265636F7264732073797374656D206576656E747320746F207379736C6F672E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31313A227379736C6F672E74657374223B7D733A393A22636F6E666967757265223B733A33323A2261646D696E2F636F6E6669672F646576656C6F706D656E742F6C6F6767696E67223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/system/system.module','system','module','',1,0,7079,0,X'613A31343A7B733A343A226E616D65223B733A363A2253797374656D223B733A31313A226465736372697074696F6E223B733A35343A2248616E646C65732067656E6572616C207369746520636F6E66696775726174696F6E20666F722061646D696E6973747261746F72732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A363A7B693A303B733A31393A2273797374656D2E61726368697665722E696E63223B693A313B733A31353A2273797374656D2E6D61696C2E696E63223B693A323B733A31363A2273797374656D2E71756575652E696E63223B693A333B733A31343A2273797374656D2E7461722E696E63223B693A343B733A31383A2273797374656D2E757064617465722E696E63223B693A353B733A31313A2273797374656D2E74657374223B7D733A383A227265717569726564223B623A313B733A393A22636F6E666967757265223B733A31393A2261646D696E2F636F6E6669672F73797374656D223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/system/tests/cron_queue_test.module','cron_queue_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A2243726F6E2051756575652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F72207468652063726F6E2071756575652072756E6E65722E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/taxonomy/taxonomy.module','taxonomy','module','',1,0,7011,0,X'613A31333A7B733A343A226E616D65223B733A383A225461786F6E6F6D79223B733A31313A226465736372697074696F6E223B733A33383A22456E61626C6573207468652063617465676F72697A6174696F6E206F6620636F6E74656E742E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A373A226F7074696F6E73223B7D733A353A2266696C6573223B613A323A7B693A303B733A31353A227461786F6E6F6D792E6D6F64756C65223B693A313B733A31333A227461786F6E6F6D792E74657374223B7D733A393A22636F6E666967757265223B733A32343A2261646D696E2F7374727563747572652F7461786F6E6F6D79223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/toolbar/toolbar.module','toolbar','module','',1,0,0,0,X'613A31323A7B733A343A226E616D65223B733A373A22546F6F6C626172223B733A31313A226465736372697074696F6E223B733A39393A2250726F7669646573206120746F6F6C62617220746861742073686F77732074686520746F702D6C6576656C2061646D696E697374726174696F6E206D656E75206974656D7320616E64206C696E6B732066726F6D206F74686572206D6F64756C65732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/tracker/tracker.module','tracker','module','',0,0,-1,0,X'613A31323A7B733A343A226E616D65223B733A373A22547261636B6572223B733A31313A226465736372697074696F6E223B733A34353A22456E61626C657320747261636B696E67206F6620726563656E7420636F6E74656E7420666F722075736572732E223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A373A22636F6D6D656E74223B7D733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31323A22747261636B65722E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/translation/tests/translation_test.module','translation_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32343A22436F6E74656E74205472616E736C6174696F6E2054657374223B733A31313A226465736372697074696F6E223B733A34393A22537570706F7274206D6F64756C6520666F722074686520636F6E74656E74207472616E736C6174696F6E2074657374732E223B733A343A22636F7265223B733A333A22372E78223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/translation/translation.module','translation','module','',0,0,-1,0,X'613A31323A7B733A343A226E616D65223B733A31393A22436F6E74656E74207472616E736C6174696F6E223B733A31313A226465736372697074696F6E223B733A35373A22416C6C6F777320636F6E74656E7420746F206265207472616E736C6174656420696E746F20646966666572656E74206C616E6775616765732E223B733A31323A22646570656E64656E63696573223B613A313A7B693A303B733A363A226C6F63616C65223B7D733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31363A227472616E736C6174696F6E2E74657374223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/trigger/tests/trigger_test.module','trigger_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31323A22547269676765722054657374223B733A31313A226465736372697074696F6E223B733A33333A22537570706F7274206D6F64756C6520666F7220547269676765722074657374732E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/trigger/trigger.module','trigger','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A373A2254726967676572223B733A31313A226465736372697074696F6E223B733A39303A22456E61626C657320616374696F6E7320746F206265206669726564206F6E206365727461696E2073797374656D206576656E74732C2073756368206173207768656E206E657720636F6E74656E7420697320637265617465642E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31323A22747269676765722E74657374223B7D733A393A22636F6E666967757265223B733A32333A2261646D696E2F7374727563747572652F74726967676572223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/update/tests/aaa_update_test.module','aaa_update_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A22414141205570646174652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220757064617465206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/update/tests/bbb_update_test.module','bbb_update_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A22424242205570646174652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220757064617465206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/update/tests/ccc_update_test.module','ccc_update_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31353A22434343205570646174652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220757064617465206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/update/tests/update_test.module','update_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31313A225570646174652074657374223B733A31313A226465736372697074696F6E223B733A34313A22537570706F7274206D6F64756C6520666F7220757064617465206D6F64756C652074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/update/update.module','update','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A31343A22557064617465206D616E61676572223B733A31313A226465736372697074696F6E223B733A3130343A22436865636B7320666F7220617661696C61626C6520757064617465732C20616E642063616E207365637572656C7920696E7374616C6C206F7220757064617465206D6F64756C657320616E64207468656D65732076696120612077656220696E746572666163652E223B733A373A2276657273696F6E223B733A343A22372E3337223B733A373A227061636B616765223B733A343A22436F7265223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A313A7B693A303B733A31313A227570646174652E74657374223B7D733A393A22636F6E666967757265223B733A33303A2261646D696E2F7265706F7274732F757064617465732F73657474696E6773223B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('modules/user/tests/user_form_test.module','user_form_test','module','',0,0,-1,0,X'613A31333A7B733A343A226E616D65223B733A32323A2255736572206D6F64756C6520666F726D207465737473223B733A31313A226465736372697074696F6E223B733A33373A22537570706F7274206D6F64756C6520666F72207573657220666F726D2074657374696E672E223B733A373A227061636B616765223B733A373A2254657374696E67223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A363A2268696464656E223B623A313B733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B7D'),
	('modules/user/user.module','user','module','',1,0,7018,0,X'613A31353A7B733A343A226E616D65223B733A343A2255736572223B733A31313A226465736372697074696F6E223B733A34373A224D616E6167657320746865207573657220726567697374726174696F6E20616E64206C6F67696E2073797374656D2E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A353A2266696C6573223B613A323A7B693A303B733A31313A22757365722E6D6F64756C65223B693A313B733A393A22757365722E74657374223B7D733A383A227265717569726564223B623A313B733A393A22636F6E666967757265223B733A31393A2261646D696E2F636F6E6669672F70656F706C65223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A383A22757365722E637373223B733A32313A226D6F64756C65732F757365722F757365722E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A31323A22646570656E64656E63696573223B613A303A7B7D733A333A22706870223B733A353A22352E322E34223B733A393A22626F6F747374726170223B693A303B7D'),
	('profiles/standard/standard.profile','standard','module','',1,0,0,1000,X'613A31353A7B733A343A226E616D65223B733A383A225374616E64617264223B733A31313A226465736372697074696F6E223B733A35313A22496E7374616C6C207769746820636F6D6D6F6E6C792075736564206665617475726573207072652D636F6E666967757265642E223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31323A22646570656E64656E63696573223B613A32313A7B693A303B733A353A22626C6F636B223B693A313B733A353A22636F6C6F72223B693A323B733A373A22636F6D6D656E74223B693A333B733A31303A22636F6E7465787475616C223B693A343B733A393A2264617368626F617264223B693A353B733A343A2268656C70223B693A363B733A353A22696D616765223B693A373B733A343A226C697374223B693A383B733A343A226D656E75223B693A393B733A363A226E756D626572223B693A31303B733A373A226F7074696F6E73223B693A31313B733A343A2270617468223B693A31323B733A383A227461786F6E6F6D79223B693A31333B733A353A2264626C6F67223B693A31343B733A363A22736561726368223B693A31353B733A383A2273686F7274637574223B693A31363B733A373A22746F6F6C626172223B693A31373B733A373A226F7665726C6179223B693A31383B733A383A226669656C645F7569223B693A31393B733A343A2266696C65223B693A32303B733A333A22726466223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A353A226D74696D65223B693A313433303937333135343B733A373A227061636B616765223B733A353A224F74686572223B733A333A22706870223B733A353A22352E322E34223B733A353A2266696C6573223B613A303A7B7D733A393A22626F6F747374726170223B693A303B733A363A2268696464656E223B623A313B733A383A227265717569726564223B623A313B733A31373A22646973747269627574696F6E5F6E616D65223B733A363A2244727570616C223B7D'),
	('themes/bartik/bartik.info','bartik','theme','themes/engines/phptemplate/phptemplate.engine',1,0,-1,0,X'613A31393A7B733A343A226E616D65223B733A363A2242617274696B223B733A31313A226465736372697074696F6E223B733A34383A224120666C657869626C652C207265636F6C6F7261626C65207468656D652077697468206D616E7920726567696F6E732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A333A7B733A31343A226373732F6C61796F75742E637373223B733A32383A227468656D65732F62617274696B2F6373732F6C61796F75742E637373223B733A31333A226373732F7374796C652E637373223B733A32373A227468656D65732F62617274696B2F6373732F7374796C652E637373223B733A31343A226373732F636F6C6F72732E637373223B733A32383A227468656D65732F62617274696B2F6373732F636F6C6F72732E637373223B7D733A353A227072696E74223B613A313A7B733A31333A226373732F7072696E742E637373223B733A32373A227468656D65732F62617274696B2F6373732F7072696E742E637373223B7D7D733A373A22726567696F6E73223B613A32303A7B733A363A22686561646572223B733A363A22486561646572223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A383A226665617475726564223B733A383A224665617475726564223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A31333A22736964656261725F6669727374223B733A31333A2253696465626172206669727374223B733A31343A22736964656261725F7365636F6E64223B733A31343A2253696465626172207365636F6E64223B733A31343A2274726970747963685F6669727374223B733A31343A225472697074796368206669727374223B733A31353A2274726970747963685F6D6964646C65223B733A31353A225472697074796368206D6964646C65223B733A31333A2274726970747963685F6C617374223B733A31333A225472697074796368206C617374223B733A31383A22666F6F7465725F6669727374636F6C756D6E223B733A31393A22466F6F74657220666972737420636F6C756D6E223B733A31393A22666F6F7465725F7365636F6E64636F6C756D6E223B733A32303A22466F6F746572207365636F6E6420636F6C756D6E223B733A31383A22666F6F7465725F7468697264636F6C756D6E223B733A31393A22466F6F74657220746869726420636F6C756D6E223B733A31393A22666F6F7465725F666F75727468636F6C756D6E223B733A32303A22466F6F74657220666F7572746820636F6C756D6E223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2230223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32383A227468656D65732F62617274696B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D'),
	('themes/garland/garland.info','garland','theme','themes/engines/phptemplate/phptemplate.engine',0,0,-1,0,X'613A31393A7B733A343A226E616D65223B733A373A224761726C616E64223B733A31313A226465736372697074696F6E223B733A3131313A2241206D756C74692D636F6C756D6E207468656D652077686963682063616E20626520636F6E6669677572656420746F206D6F6469667920636F6C6F727320616E6420737769746368206265747765656E20666978656420616E6420666C756964207769647468206C61796F7574732E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A323A7B733A333A22616C6C223B613A313A7B733A393A227374796C652E637373223B733A32343A227468656D65732F6761726C616E642F7374796C652E637373223B7D733A353A227072696E74223B613A313A7B733A393A227072696E742E637373223B733A32343A227468656D65732F6761726C616E642F7072696E742E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A31333A226761726C616E645F7769647468223B733A353A22666C756964223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32393A227468656D65732F6761726C616E642F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D'),
	('themes/seven/seven.info','seven','theme','themes/engines/phptemplate/phptemplate.engine',1,0,-1,0,X'613A31393A7B733A343A226E616D65223B733A353A22536576656E223B733A31313A226465736372697074696F6E223B733A36353A22412073696D706C65206F6E652D636F6C756D6E2C207461626C656C6573732C20666C7569642077696474682061646D696E697374726174696F6E207468656D652E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A363A2273637265656E223B613A323A7B733A393A2272657365742E637373223B733A32323A227468656D65732F736576656E2F72657365742E637373223B733A393A227374796C652E637373223B733A32323A227468656D65732F736576656E2F7374796C652E637373223B7D7D733A383A2273657474696E6773223B613A313A7B733A32303A2273686F72746375745F6D6F64756C655F6C696E6B223B733A313A2231223B7D733A373A22726567696F6E73223B613A383A7B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31333A22736964656261725F6669727374223B733A31333A2246697273742073696465626172223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A31343A22726567696F6E735F68696464656E223B613A333A7B693A303B733A31333A22736964656261725F6669727374223B693A313B733A383A22706167655F746F70223B693A323B733A31313A22706167655F626F74746F6D223B7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F736576656E2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D'),
	('themes/stark/stark.info','stark','theme','themes/engines/phptemplate/phptemplate.engine',0,0,-1,0,X'613A31383A7B733A343A226E616D65223B733A353A22537461726B223B733A31313A226465736372697074696F6E223B733A3230383A2254686973207468656D652064656D6F6E737472617465732044727570616C27732064656661756C742048544D4C206D61726B757020616E6420435353207374796C65732E20546F206C6561726E20686F7720746F206275696C6420796F7572206F776E207468656D6520616E64206F766572726964652044727570616C27732064656661756C7420636F64652C2073656520746865203C6120687265663D22687474703A2F2F64727570616C2E6F72672F7468656D652D6775696465223E5468656D696E672047756964653C2F613E2E223B733A373A227061636B616765223B733A343A22436F7265223B733A373A2276657273696F6E223B733A343A22372E3337223B733A343A22636F7265223B733A333A22372E78223B733A31313A227374796C65736865657473223B613A313A7B733A333A22616C6C223B613A313A7B733A31303A226C61796F75742E637373223B733A32333A227468656D65732F737461726B2F6C61796F75742E637373223B7D7D733A373A2270726F6A656374223B733A363A2264727570616C223B733A393A22646174657374616D70223B733A31303A2231343330393733313534223B733A363A22656E67696E65223B733A31313A2270687074656D706C617465223B733A373A22726567696F6E73223B613A31323A7B733A31333A22736964656261725F6669727374223B733A31323A224C6566742073696465626172223B733A31343A22736964656261725F7365636F6E64223B733A31333A2252696768742073696465626172223B733A373A22636F6E74656E74223B733A373A22436F6E74656E74223B733A363A22686561646572223B733A363A22486561646572223B733A363A22666F6F746572223B733A363A22466F6F746572223B733A31313A22686967686C696768746564223B733A31313A22486967686C696768746564223B733A343A2268656C70223B733A343A2248656C70223B733A383A22706167655F746F70223B733A383A225061676520746F70223B733A31313A22706167655F626F74746F6D223B733A31313A225061676520626F74746F6D223B733A31343A2264617368626F6172645F6D61696E223B733A31363A2244617368626F61726420286D61696E29223B733A31373A2264617368626F6172645F73696465626172223B733A31393A2244617368626F61726420287369646562617229223B733A31383A2264617368626F6172645F696E616374697665223B733A32303A2244617368626F6172642028696E61637469766529223B7D733A383A226665617475726573223B613A393A7B693A303B733A343A226C6F676F223B693A313B733A373A2266617669636F6E223B693A323B733A343A226E616D65223B693A333B733A363A22736C6F67616E223B693A343B733A31373A226E6F64655F757365725F70696374757265223B693A353B733A32303A22636F6D6D656E745F757365725F70696374757265223B693A363B733A32353A22636F6D6D656E745F757365725F766572696669636174696F6E223B693A373B733A393A226D61696E5F6D656E75223B693A383B733A31343A227365636F6E646172795F6D656E75223B7D733A31303A2273637265656E73686F74223B733A32373A227468656D65732F737461726B2F73637265656E73686F742E706E67223B733A333A22706870223B733A353A22352E322E34223B733A373A2273637269707473223B613A303A7B7D733A353A226D74696D65223B693A313433303937333135343B733A31353A226F7665726C61795F726567696F6E73223B613A353A7B693A303B733A31343A2264617368626F6172645F6D61696E223B693A313B733A31373A2264617368626F6172645F73696465626172223B693A323B733A31383A2264617368626F6172645F696E616374697665223B693A333B733A373A22636F6E74656E74223B693A343B733A343A2268656C70223B7D733A31343A22726567696F6E735F68696464656E223B613A323A7B693A303B733A383A22706167655F746F70223B693A313B733A31313A22706167655F626F74746F6D223B7D733A32383A226F7665726C61795F737570706C656D656E74616C5F726567696F6E73223B613A313A7B693A303B733A383A22706167655F746F70223B7D7D');

/*!40000 ALTER TABLE `system` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table taxonomy_index
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taxonomy_index`;

CREATE TABLE `taxonomy_index` (
  `nid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The node.nid this record tracks.',
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The term ID.',
  `sticky` tinyint(4) DEFAULT '0' COMMENT 'Boolean indicating whether the node is sticky.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'The Unix timestamp when the node was created.',
  KEY `term_node` (`tid`,`sticky`,`created`),
  KEY `nid` (`nid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maintains denormalized information about node/term...';



# Dump of table taxonomy_term_data
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taxonomy_term_data`;

CREATE TABLE `taxonomy_term_data` (
  `tid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique term ID.',
  `vid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The taxonomy_vocabulary.vid of the vocabulary to which the term is assigned.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The term name.',
  `description` longtext COMMENT 'A description of the term.',
  `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the description.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this term in relation to other terms.',
  PRIMARY KEY (`tid`),
  KEY `taxonomy_tree` (`vid`,`weight`,`name`),
  KEY `vid_name` (`vid`,`name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores term information.';



# Dump of table taxonomy_term_hierarchy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taxonomy_term_hierarchy`;

CREATE TABLE `taxonomy_term_hierarchy` (
  `tid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: The taxonomy_term_data.tid of the term.',
  `parent` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: The taxonomy_term_data.tid of the term’s parent. 0 indicates no parent.',
  PRIMARY KEY (`tid`,`parent`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores the hierarchical relationship between terms.';



# Dump of table taxonomy_vocabulary
# ------------------------------------------------------------

DROP TABLE IF EXISTS `taxonomy_vocabulary`;

CREATE TABLE `taxonomy_vocabulary` (
  `vid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique vocabulary ID.',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'Name of the vocabulary.',
  `machine_name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The vocabulary machine name.',
  `description` longtext COMMENT 'Description of the vocabulary.',
  `hierarchy` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'The type of hierarchy allowed within the vocabulary. (0 = disabled, 1 = single, 2 = multiple)',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT 'The module which created the vocabulary.',
  `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this vocabulary in relation to other vocabularies.',
  PRIMARY KEY (`vid`),
  UNIQUE KEY `machine_name` (`machine_name`),
  KEY `list` (`weight`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores vocabulary information.';

LOCK TABLES `taxonomy_vocabulary` WRITE;
/*!40000 ALTER TABLE `taxonomy_vocabulary` DISABLE KEYS */;

INSERT INTO `taxonomy_vocabulary` (`vid`, `name`, `machine_name`, `description`, `hierarchy`, `module`, `weight`)
VALUES
	(1,'Tags','tags','Use tags to group articles on similar topics into categories.',0,'taxonomy',0);

/*!40000 ALTER TABLE `taxonomy_vocabulary` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table url_alias
# ------------------------------------------------------------

DROP TABLE IF EXISTS `url_alias`;

CREATE TABLE `url_alias` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'A unique path alias identifier.',
  `source` varchar(255) NOT NULL DEFAULT '' COMMENT 'The Drupal path this alias is for; e.g. node/12.',
  `alias` varchar(255) NOT NULL DEFAULT '' COMMENT 'The alias for this path; e.g. title-of-the-story.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'The language this alias is for; if ’und’, the alias will be used for unknown languages. Each Drupal path can have an alias for each supported language.',
  PRIMARY KEY (`pid`),
  KEY `alias_language_pid` (`alias`,`language`,`pid`),
  KEY `source_language_pid` (`source`,`language`,`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='A list of URL aliases for Drupal paths; a user may visit...';



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: Unique user ID.',
  `name` varchar(60) NOT NULL DEFAULT '' COMMENT 'Unique user name.',
  `pass` varchar(128) NOT NULL DEFAULT '' COMMENT 'User’s password (hashed).',
  `mail` varchar(254) DEFAULT '' COMMENT 'User’s e-mail address.',
  `theme` varchar(255) NOT NULL DEFAULT '' COMMENT 'User’s default theme.',
  `signature` varchar(255) NOT NULL DEFAULT '' COMMENT 'User’s signature.',
  `signature_format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the signature.',
  `created` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for when user was created.',
  `access` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for previous time user accessed the site.',
  `login` int(11) NOT NULL DEFAULT '0' COMMENT 'Timestamp for user’s last login.',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Whether the user is active(1) or blocked(0).',
  `timezone` varchar(32) DEFAULT NULL COMMENT 'User’s time zone.',
  `language` varchar(12) NOT NULL DEFAULT '' COMMENT 'User’s default language.',
  `picture` int(11) NOT NULL DEFAULT '0' COMMENT 'Foreign key: file_managed.fid of user’s picture.',
  `init` varchar(254) DEFAULT '' COMMENT 'E-mail address used for initial account creation.',
  `data` longblob COMMENT 'A serialized array of name value pairs that are related to the user. Any form values posted during user edit are stored and are loaded into the $user object during user_load(). Use of this field is discouraged and it will likely disappear in a future...',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `name` (`name`),
  KEY `access` (`access`),
  KEY `created` (`created`),
  KEY `mail` (`mail`),
  KEY `picture` (`picture`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Stores user data.';

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`uid`, `name`, `pass`, `mail`, `theme`, `signature`, `signature_format`, `created`, `access`, `login`, `status`, `timezone`, `language`, `picture`, `init`, `data`)
VALUES
	(0,'','','','','',NULL,0,0,0,0,NULL,'',0,'',NULL),
	(1,'vagrant','$S$DZqVHXawb.WFaPyCG7Vn8EUvIcuMwwbcoTFgMtj9mCTbuA777Pus','vagrant@acquia.com','','',NULL,1433074499,1433074564,1433074564,1,'Australia/Melbourne','',0,'vagrant@acquia.com',X'623A303B');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table users_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users_roles`;

CREATE TABLE `users_roles` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: users.uid for user.',
  `rid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: role.rid for role.',
  PRIMARY KEY (`uid`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps users to roles.';

LOCK TABLES `users_roles` WRITE;
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;

INSERT INTO `users_roles` (`uid`, `rid`)
VALUES
	(1,3);

/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table variable
# ------------------------------------------------------------

DROP TABLE IF EXISTS `variable`;

CREATE TABLE `variable` (
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT 'The name of the variable.',
  `value` longblob NOT NULL COMMENT 'The value of the variable.',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Named variable/value pairs created by Drupal core or any...';

LOCK TABLES `variable` WRITE;
/*!40000 ALTER TABLE `variable` DISABLE KEYS */;

INSERT INTO `variable` (`name`, `value`)
VALUES
	('admin_theme',X'733A353A22736576656E223B'),
	('clean_url',X'733A313A2231223B'),
	('comment_page',X'693A303B'),
	('cron_key',X'733A34333A2274356E6473676767664A56706F6C332D4E376170566C4C584F573178644637554D312D695454646E314E4D223B'),
	('cron_last',X'693A313433333037343536343B'),
	('css_js_query_string',X'733A363A226E7037726573223B'),
	('date_default_timezone',X'733A31393A224175737472616C69612F4D656C626F75726E65223B'),
	('drupal_private_key',X'733A34333A22626434556C4C766861427069447854464F5645754F3734474D4A30656862415665735A54333250446D3238223B'),
	('file_temporary_path',X'733A343A222F746D70223B'),
	('filter_fallback_format',X'733A31303A22706C61696E5F74657874223B'),
	('install_profile',X'733A383A227374616E64617264223B'),
	('install_task',X'733A343A22646F6E65223B'),
	('install_time',X'693A313433333037343536343B'),
	('menu_expanded',X'613A303A7B7D'),
	('menu_masks',X'613A33343A7B693A303B693A3530313B693A313B693A3439333B693A323B693A3235303B693A333B693A3234373B693A343B693A3234363B693A353B693A3234353B693A363B693A3132353B693A373B693A3132333B693A383B693A3132323B693A393B693A3132313B693A31303B693A3131373B693A31313B693A36333B693A31323B693A36323B693A31333B693A36313B693A31343B693A36303B693A31353B693A35393B693A31363B693A35383B693A31373B693A34343B693A31383B693A33313B693A31393B693A33303B693A32303B693A32393B693A32313B693A32383B693A32323B693A32343B693A32333B693A32313B693A32343B693A31353B693A32353B693A31343B693A32363B693A31333B693A32373B693A31313B693A32383B693A373B693A32393B693A363B693A33303B693A353B693A33313B693A333B693A33323B693A323B693A33333B693A313B7D'),
	('node_admin_theme',X'733A313A2231223B'),
	('node_options_page',X'613A313A7B693A303B733A363A22737461747573223B7D'),
	('node_submitted_page',X'623A303B'),
	('path_alias_whitelist',X'613A303A7B7D'),
	('site_default_country',X'733A323A224155223B'),
	('site_mail',X'733A31383A2276616772616E74406163717569612E636F6D223B'),
	('site_name',X'733A31343A224163717569612056616772616E74223B'),
	('theme_default',X'733A363A2262617274696B223B'),
	('user_admin_role',X'733A313A2233223B'),
	('user_pictures',X'733A313A2231223B'),
	('user_picture_dimensions',X'733A393A22313032347831303234223B'),
	('user_picture_file_size',X'733A333A22383030223B'),
	('user_picture_style',X'733A393A227468756D626E61696C223B'),
	('user_register',X'693A323B');

/*!40000 ALTER TABLE `variable` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table watchdog
# ------------------------------------------------------------

DROP TABLE IF EXISTS `watchdog`;

CREATE TABLE `watchdog` (
  `wid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique watchdog event ID.',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT 'The users.uid of the user who triggered the event.',
  `type` varchar(64) NOT NULL DEFAULT '' COMMENT 'Type of log message, for example "user" or "page not found."',
  `message` longtext NOT NULL COMMENT 'Text of log message to be passed into the t() function.',
  `variables` longblob NOT NULL COMMENT 'Serialized array of variables that match the message string and that is passed into the t() function.',
  `severity` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'The severity level of the event; ranges from 0 (Emergency) to 7 (Debug)',
  `link` varchar(255) DEFAULT '' COMMENT 'Link to view the result of the event.',
  `location` text NOT NULL COMMENT 'URL of the origin of the event.',
  `referer` text COMMENT 'URL of referring page.',
  `hostname` varchar(128) NOT NULL DEFAULT '' COMMENT 'Hostname of the user who triggered the event.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Unix timestamp of when event occurred.',
  PRIMARY KEY (`wid`),
  KEY `type` (`type`),
  KEY `uid` (`uid`),
  KEY `severity` (`severity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table that contains logs of all system events.';




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
