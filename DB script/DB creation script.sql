
CREATE TABLE `account` (
  `id` varchar(255) NOT NULL,
  `age` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `interest1` varchar(255) DEFAULT NULL,
  `interest2` varchar(255) DEFAULT NULL,
  `interest3` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `profile_image_location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `application` (
  `account_id` varchar(255) NOT NULL,
  `event_id` bigint NOT NULL,
  `cloud_video_file_location` varchar(255) DEFAULT NULL,
  `is_approved` bit(1) NOT NULL,
  PRIMARY KEY (`account_id`,`event_id`),
  UNIQUE KEY `UK_lmlp834uogha7umdaxxresjbh` (`account_id`),
  KEY `FKhnj44s1vum4por0ctctfeciwi` (`event_id`),
  CONSTRAINT `FKhnj44s1vum4por0ctctfeciwi` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`),
  CONSTRAINT `FKky75lx3vuxr3ttohuu3kbu406` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `event` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `is_closed` bit(1) NOT NULL,
  `video_location` varchar(255) DEFAULT NULL,
  `account_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqy7vf2v6cfnvo3nxba11fush5` (`account_id`),
  CONSTRAINT `FKqy7vf2v6cfnvo3nxba11fush5` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `event_applications` (
  `event_id` bigint NOT NULL,
  `applications_account_id` varchar(255) NOT NULL,
  `applications_event_id` bigint NOT NULL,
  PRIMARY KEY (`event_id`,`applications_account_id`,`applications_event_id`),
  UNIQUE KEY `UK_lurnep3jlbb4vkdvr8dfbrypg` (`applications_account_id`,`applications_event_id`),
  CONSTRAINT `FK9bg8exe87jr27yhk30lmgy7as` FOREIGN KEY (`applications_account_id`, `applications_event_id`) REFERENCES `application` (`account_id`, `event_id`),
  CONSTRAINT `FKkh5ntr8mqkfes5pje0b3i9ilu` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `event_image` (
  `image_location` varchar(255) NOT NULL,
  `image_description` varchar(255) DEFAULT NULL,
  `event_id` bigint DEFAULT NULL,
  PRIMARY KEY (`image_location`),
  KEY `FK9oirj7cwmu7k91vr0m13hqh8b` (`event_id`),
  CONSTRAINT `FK9oirj7cwmu7k91vr0m13hqh8b` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
