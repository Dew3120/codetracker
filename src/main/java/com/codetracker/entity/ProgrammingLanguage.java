package com.codetracker.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

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

    @Builder.Default
    @Column(name = "color_hex", nullable = false, length = 7, columnDefinition = "VARCHAR(7) NOT NULL DEFAULT '#808080'")
    private String colorHex = "#808080";

    @Builder.Default
    @OneToMany(mappedBy = "language", fetch = FetchType.LAZY)
    @JsonIgnore
    private List<CodingSession> sessions = new ArrayList<>();
}
