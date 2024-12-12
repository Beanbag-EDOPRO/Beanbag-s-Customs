Move this file to the config folder of your EDOPro installation (e.g. /ProjectIgnis/config). Attention: If you already have this file in this folder, other configurations will be overwritten.

In this case you can edit the existing file. Search the line that starts with "repos": [ and insert the following code directly below it:

		{
			"url": "https://github.com/Beanbag-EDOPRO/Beanbag-s-Customs",
			"repo_name": "Beanbags",
			"repo_path": "./repositories/beans",
			"should_update": true,
			"should_read": true
		}
