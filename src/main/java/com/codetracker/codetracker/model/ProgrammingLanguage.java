package com.codetracker.codetracker.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "programming_languages")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProgrammingLanguage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String name;

    @Column(name = "color_hex", nullable = false, length = 7)
    private String colorHex;

    @OneToMany(mappedBy = "language", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<CodingSession> sessions = new ArrayList<>();
}