package com.aperture.auto.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AutoController {
    @GetMapping("/api/public")
    public String pubicMethod() {
        return "Public api";
    }

    @GetMapping("/api/user")
    public String userMethod() {
        return "User api";
    }

    @GetMapping("/api/admin")
    public String adminMethod() {
        return "Admin api";
    }
}