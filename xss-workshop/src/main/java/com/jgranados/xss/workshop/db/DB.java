/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.jgranados.xss.workshop.db;

import jakarta.servlet.ServletContext;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author jose
 */
public class DB {
    // Simular una base de datos en memoria

    List<Map<String, String>> commentsDB = new ArrayList<>();
    List<Map<String, String>> messagesDB = new ArrayList<>();
    List<Map<String, String>> userProfilesDB = new ArrayList<>();
    String dataFile;

    public DB(ServletContext application) {
        dataFile = application.getRealPath("/") + "stored_xss_data.txt";
// Cargar datos existentes del archivo (si existe)
        try {
            if (new File(dataFile).exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(dataFile));
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.startsWith("COMMENT:")) {
                        String[] parts = line.substring(8).split("\\|");
                        if (parts.length >= 3) {
                            Map<String, String> comment = new HashMap<>();
                            comment.put("id", parts[0]);
                            comment.put("user", parts[1]);
                            comment.put("content", parts[2]);
                            comment.put("timestamp", parts.length > 3 ? parts[3] : "Unknown");
                            commentsDB.add(comment);
                        }
                    } else if (line.startsWith("MESSAGE:")) {
                        String[] parts = line.substring(8).split("\\|");
                        if (parts.length >= 3) {
                            Map<String, String> message = new HashMap<>();
                            message.put("id", parts[0]);
                            message.put("from", parts[1]);
                            message.put("content", parts[2]);
                            message.put("timestamp", parts.length > 3 ? parts[3] : "Unknown");
                            messagesDB.add(message);
                        }
                    } else if (line.startsWith("PROFILE:")) {
                        String[] parts = line.substring(8).split("\\|");
                        if (parts.length >= 3) {
                            Map<String, String> profile = new HashMap<>();
                            profile.put("id", parts[0]);
                            profile.put("username", parts[1]);
                            profile.put("bio", parts[2]);
                            userProfilesDB.add(profile);
                        }
                    }
                }
                reader.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void saveToFile() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(dataFile))) {
            for (Map<String, String> comment : commentsDB) {
                writer.println("COMMENT:" + comment.get("id") + "|" + comment.get("user") + "|"
                        + comment.get("content") + "|" + comment.get("timestamp"));
            }
            for (Map<String, String> message : messagesDB) {
                writer.println("MESSAGE:" + message.get("id") + "|" + message.get("from") + "|"
                        + message.get("content") + "|" + message.get("timestamp"));
            }
            for (Map<String, String> profile : userProfilesDB) {
                writer.println("PROFILE:" + profile.get("id") + "|" + profile.get("username") + "|"
                        + profile.get("bio"));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void clear() {
        commentsDB.clear();
        messagesDB.clear();
        userProfilesDB.clear();
        saveToFile();
    }

    public List<Map<String, String>> getCommentsDB() {
        return commentsDB;
    }

    public void setCommentsDB(List<Map<String, String>> commentsDB) {
        this.commentsDB = commentsDB;
    }

    public List<Map<String, String>> getMessagesDB() {
        return messagesDB;
    }

    public void setMessagesDB(List<Map<String, String>> messagesDB) {
        this.messagesDB = messagesDB;
    }

    public List<Map<String, String>> getUserProfilesDB() {
        return userProfilesDB;
    }

    public void setUserProfilesDB(List<Map<String, String>> userProfilesDB) {
        this.userProfilesDB = userProfilesDB;
    }

}
