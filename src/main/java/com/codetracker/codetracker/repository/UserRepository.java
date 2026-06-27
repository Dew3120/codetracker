package com.codetracker.codetracker.repository;

import com.codetracker.codetracker.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Find a user by their username.
     * @param username the username to search for
     * @return an Optional containing the User if found
     */
    Optional<User> findByUsername(String username);

    /**
     * Find a user by their email.
     * @param email the email to search for
     * @return an Optional containing the User if found
     */
    Optional<User> findByEmail(String email);

    /**
     * Check whether a user exists with the given username.
     * @param username the username to check
     * @return true if a user with the username exists
     */
    boolean existsByUsername(String username);

    /**
     * Check whether a user exists with the given email.
     * @param email the email to check
     * @return true if a user with the email exists
     */
    boolean existsByEmail(String email);
}

