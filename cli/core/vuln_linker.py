"""
cli/core/vuln_linker.py — Link module names tới vuln-db entries
"""
import os
import json


class VulnLinker:
    def __init__(self, map_path=None):
        if map_path is None:
            map_path = os.path.join(os.path.dirname(__file__), "vuln_map.json")
        with open(map_path, "r", encoding="utf-8") as f:
            self._map: dict = json.load(f)

    def link(self, module_name: str) -> str | None:
        """
        Tìm vuln-db ID tương ứng với tên module.
        Thử exact match trước, sau đó substring match.
        """
        module_lower = module_name.lower().replace("-", "_")
        # Exact match
        if module_lower in self._map:
            return self._map[module_lower]
        # Substring match
        for key, vuln_id in self._map.items():
            if key in module_lower or module_lower in key:
                return vuln_id
        return None

    def link_all(self, module_names: list) -> dict:
        return {name: self.link(name) for name in module_names}
