package tech.nguyenstudy0504.learningplatform.service;

import tech.nguyenstudy0504.learningplatform.model.Lecture;
import tech.nguyenstudy0504.learningplatform.repository.LectureRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class LectureService {

    @Autowired
    private LectureRepository lectureRepository;

    // Lecture CRUD operations
    public Lecture createLecture(Lecture lecture) {
        return lectureRepository.save(lecture);
    }

    public Lecture updateLecture(Lecture lecture) {
        return lectureRepository.save(lecture);
    }

    public void deleteLecture(Long id) {
        lectureRepository.deleteById(id);
    }

    public Optional<Lecture> findById(Long id) {
        return lectureRepository.findById(id);
    }

    public Optional<Lecture> findByIdAndActive(Long id) {
        return lectureRepository.findByIdAndStatus(id, Lecture.Status.PUBLISHED);
    }

    public List<Lecture> findAllLectures() {
        return lectureRepository.findAll();
    }

    public List<Lecture> findLecturesByCourse(Long courseId) {
        return lectureRepository.findActiveLecturesByCourseId(courseId);
    }

    public List<Lecture> findLecturesByCourseOrdered(Long courseId) {
        return lectureRepository.findByCourseIdOrderByOrderIndexAsc(courseId);
    }

    // Search operations
    public List<Lecture> searchLectures(String searchTerm) {
        return lectureRepository.searchLectures(searchTerm);
    }

    public List<Lecture> findLecturesByTitle(String title) {
        return lectureRepository.findByTitleContaining(title);
    }

    public List<Lecture> findLecturesByContent(String content) {
        return lectureRepository.findByContentContaining(content);
    }

    // Lecture management
    public void activateLecture(Long lectureId) {
        Optional<Lecture> lectureOpt = lectureRepository.findById(lectureId);
        if (lectureOpt.isPresent()) {
            Lecture lecture = lectureOpt.get();
            lecture.setStatus(Lecture.Status.PUBLISHED);
            lectureRepository.save(lecture);
        }
    }

    public void deactivateLecture(Long lectureId) {
        Optional<Lecture> lectureOpt = lectureRepository.findById(lectureId);
        if (lectureOpt.isPresent()) {
            Lecture lecture = lectureOpt.get();
            lecture.setStatus(Lecture.Status.DRAFT);
            lectureRepository.save(lecture);
        }
    }

    // Order management
    public void reorderLecture(Long lectureId, Integer newOrder) {
        Optional<Lecture> lectureOpt = lectureRepository.findById(lectureId);
        if (lectureOpt.isPresent()) {
            Lecture lecture = lectureOpt.get();
            lecture.setOrder(newOrder);
            lectureRepository.save(lecture);
        }
    }

    public Integer getNextOrderIndex(Long courseId) {
        Integer maxOrder = lectureRepository.findMaxOrderIndexByCourseId(courseId);
        return (maxOrder == null) ? 1 : maxOrder + 1;
    }

    // Statistics
    public long countActiveLecturesByCourse(Long courseId) {
        return lectureRepository.countActiveLecturesByCourseId(courseId);
    }

    // Navigation
    public Optional<Lecture> getNextLecture(Long courseId, Integer currentOrderIndex) {
        List<Lecture> nextLectures = lectureRepository.findLecturesAfterOrder(courseId, currentOrderIndex);
        return nextLectures.isEmpty() ? Optional.empty() : Optional.of(nextLectures.get(0));
    }

    public Optional<Lecture> getPreviousLecture(Long courseId, Integer currentOrderIndex) {
        List<Lecture> prevLectures = lectureRepository.findLecturesBeforeOrder(courseId, currentOrderIndex);
        return prevLectures.isEmpty() ? Optional.empty() : Optional.of(prevLectures.get(0));
    }
}
