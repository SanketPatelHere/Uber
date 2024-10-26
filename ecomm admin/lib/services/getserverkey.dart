

import '../logging/logger_helper.dart';



import 'package:googleapis_auth/auth_io.dart';


class GetServerKey {
  final TAG = "Myy GetServerKey ";

  Future<String> getServerKeyToken() async{
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "ecomm-18247",
          "private_key_id": "2297be1b53acfaae1a65768dd93a7a72dd4bf942",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHNNcG2vYW5w8v\n5pDUVmsDLFHJi046RVkW/GzGegQvInhPy06Kb0MZ7wNBirPlY7W8EaEHJTWLzknb\nf/BE3VBrlLXMcNa2Pq/hzKPE0NXv51i2Egq5oQqs/bmxi0PVaJiwcxsZcjHrgrjO\n6FE4sVn9NOYiyCwMe8LRKm8ggntP4BfbLyHxYWkxnzd2NgTeRg9xrTct7ii+OHCn\nPJzuiI2ltFxXFGEfysOroQYWYS6fxsTW+EbcjLrSrZL0mo+GGWjXt/jqicgMbFP2\nth1fthHMuR+sJ9LvJgWz85ZoTNUiR5h2v8JO19JNVzxZ88175MYqfTkzDmVC0c7C\neE6sel8dAgMBAAECggEAQ9BDGvxTJfzGeMH+r6ozh8MAnKGlocSVzXNk/DPxVLJh\nTpihRhMWPq/U5ez3zLEi3sEJlksebVduYSCuhGLqy5S2RsBq92NjsHRfk9Kb4a1Z\nz7FYoVSnM7i0DDKihvWydO7aXNE5GTlI/Hatn6UQQ1hMt655AE7pRRcy+Vgx7kB7\nXVEWy6gtVIN3c0QYNu2cVt1EwtMvgJnRYVqi1iMD2tiW8b1gyOOhogRmhxdZFjL7\nwakXKfYM4+AiNkyrRBC6px8TrS2R9L+BlJDaS4NFxG8cBSBjVDB1Usfi3R1VzARM\nn66cCIRF7arFyPMv6biKT0GL+GZ3fTYCmb4YGcTo6QKBgQDjJnjUd8FgZXfCJQD+\nS4sTSY42x/YGoZI4Q6dTY0wE/1qtoPhx3wEqqJC4c0+isBBXzjdTlVgpgkXT1Qut\ngVh6WUpZnez5yGL0b4htpdmjb6oduV0eg8WZRGqJcv0HOXmbUi5/7aoMnmPtdOrq\ndJxFjUxvIDql/F9CqiF4R+o/4wKBgQDggc4lTh/9Fdu50AfMaGQPrmEZmHs9N7EB\ntc98EcpKwcrqvjq/4e7ciHHmjekhesMMbth8pBFDAwIgN42UaxuYpF3YzrK1l3DT\nNwLsAoAu19PcpytFOSSZp5Y0ZY4CcqkIdQOBIhZnl3z29LiN4D29IkCn/o7O/8rK\nJygRiO0U/wKBgQDe8i++OhwuxOiaQT+MWBEUySkwU2sCbyrY1m4wxlEixo71w/yV\np0+50uDYaTVMdIpV5C0heH+jnh1zILPpg/6Xd3QmKX8iWq/lQmMhW5sVctABhKIF\nBUi4ehIm/hmjMaJN9Id3QImbAQsLUaoQnIuVKG5Q0808hUvqXpmjONKOCQKBgCpy\ngG5vOf8Y7eVQ3tiX+Cs61iMHwG1PpUjkfilAF9ZQk7QUaXk0F3xc0+Q6epSY6F3m\na0oNnzHjVLiQqFUidyJCGXhPhFxvGKbmpMfIpUG2DtmORdEdv7zJgc3AUbxGv4zY\nyuPUdRX6/2aV2HsCpcmnuz/IEmoy1L2p75p5IBIzAoGBAKOXVPP/cX33T8UTVwLK\nnYRPZvPvUPk89YeHh27h7/4qieyqHtzGNGRj0d+u28VC/aDT8Zg0FJ8DzLXTyez6\nqgwiYd96GqzzytX3tzsElVEi5bamnNQKPA6duyc9Co/Fo7DHtX/VoE7D3JKQB5TO\npWkU5rBJBdh/SrH3VlxZ3eK5\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-8618g@ecomm-18247.iam.gserviceaccount.com",
          "client_id": "106923599008258728887",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-8618g%40ecomm-18247.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
    ),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    //ya29.c.c0ASRK0GaSEjqmppthkpkQ4W7vWQej56P2anJ0Qw_iWNaIKE80V8nhYQbchWy2jIbi_r25i9CMw63lUtnj-6FKgPLKiLoz9fxRSWZq532G0czVLEn_T3xcHFnpxpGOb4TCPMs1ePkmaq7Gv935G_eMq-u8l3miCHVjDxJzI4Fey1scdqaRe7z4xFJWWEA-hHMB7Hz8TMNwV-xtb8RY0tnahemHTqJG3JxrmUKBDOYBS2BVfOx6UT9StettFvy_LcIAspYutj9rNmivbugnvWyYJBEQYi1Z4Yb8F6mDRckhwjbvrwO-PzFOa0UclCgd8_BErZ3sT_jRYjOqH8HYrfKeUyq5W-ksM5TjDW1QBCTx503SklEUZN6jNIcPRqtAIwL391ABtusdhSi4rMBn4diUcYBqBBejWubO2ZujIa1reV134esOZqk-b4v03I1MRSW134VRWfma6Swc9a9cpqkr7j5kW__w88vy4t5q-I_5vQrzJZ71UZyuQxfXQl77l4qY76U8rs4cdxoF5cxhdsy3UiXuV5a3afF9hlm9t1gU14J1WOnjavwFhYFac20Rf8x2yiytipWYU0xq1-u49oXhdn7yq82wdbfMmuhBJWfwUkjxwWS9lrbSkXZ94nszp_XY92hI9FgMgMr74zXy-IqIhOJt77seu3_77kZUh8_UletXbzeMQaJa1hxsmzsw2dZIFVm_wv9xYU8hJb_Vh4IOm8Yrjnmmve-vwlbWIFd5cdfbep4WBO60mcJo9rdf7Vv-7B-m85ijy_y9JU_ctzIhr7RlUzwWBJOyfVcQaaixq6cZ7Rqx0-_26-z-oS2fjhjcxFtdhtc8tOrRrku5r_dbjBMUFptw8SB7WgwJXdebuXMOU13yO9eu0F3u2FiU53Jt_nzpX2uFRFlxeS0SdvqaiM-m6OvOoZipt1peweahg6jp6wtb9n
    TLoggerHelper.info("${TAG} firebase accessServerKey = "+accessServerKey);
    return accessServerKey;

  }
}