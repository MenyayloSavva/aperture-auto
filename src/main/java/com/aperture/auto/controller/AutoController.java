package com.aperture.auto.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AutoController {
    @GetMapping("/")
    public String indexPage() {
        return "Hello, Welcome to Aperture Auto!";
    }
}